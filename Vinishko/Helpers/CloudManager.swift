//
//  CloudManager.swift
//  Vinishko
//
//  Created by Денис on 30.12.2022.
//

import UIKit
import CloudKit
import RealmSwift

class CloudManager {
    
    private static let privateCloudDatabase = CKContainer(identifier: CloudConfig.containerIdentifier).privateCloudDatabase
    private static var records: [CKRecord] = []
    
    static func saveDataToCloud(bottle: Bottle, bottleImage: UIImage, closure: @escaping (String) -> ()) {
        
        let (image, url) = prepareImageToSaveToCloud(bottle: bottle, bottleImage: bottleImage)
        
        guard let imageAsset = image, let imageURL = url else { return }
        
        let record = CKRecord(recordType: "Bottle")
        record.setValue(bottle.bottleID, forKey: "bottleID")
        record.setValue(bottle.bottleDescription, forKey: "bottleDescription")
        record.setValue(imageAsset, forKey: "bottleImage")
        record.setValue(bottle.date, forKey: "date")
        record.setValue(bottle.name, forKey: "name")
        record.setValue(bottle.placeOfPurchase, forKey: "placeOfPurchase")
        record.setValue(bottle.price, forKey: "price")
        record.setValue(bottle.rating, forKey: "rating")
        record.setValue(bottle.wineColor, forKey: "wineColor")
        record.setValue(bottle.wineCountry, forKey: "wineCountry")
        record.setValue(bottle.wineRegion, forKey: "wineRegion")
        record.setValue(bottle.wineSort, forKey: "wineSort")
        record.setValue(bottle.wineSugar, forKey: "wineSugar")
        record.setValue(bottle.wineType, forKey: "wineType")
        
        privateCloudDatabase.save(record) { (newRecord, error) in
            if let error = error { print(error); return }
            if let newRecord = newRecord {
                closure(newRecord.recordID.recordName)
            }
            deleteTempImage(imageURL: imageURL)
        }
    }
    
    static func fetchDataFromCloud(bottles: Results<Bottle>, closure: @escaping (Bottle) -> ()) {
        let query = CKQuery(recordType: "Bottle", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let queryOperation = CKQueryOperation(query: query)

                queryOperation.desiredKeys = ["recordID", "bottleID", "bottleDescription", "date",
                                              "name", "placeOfPurchase", "price", "rating", "wineColor",
                                              "wineCountry", "wineRegion", "wineSort", "wineSugar", "wineType"]
        queryOperation.resultsLimit = 5
        queryOperation.queuePriority = .veryHigh
        
        queryOperation.recordFetchedBlock = { record in
            
            self.records.append(record)
            let newBottle = Bottle(record: record)
            
            DispatchQueue.main.async {
                if newCloudRecordIsAvailable(bottles: bottles, bottleID: newBottle.bottleID) {
                    closure(newBottle)
                }
            }
        }
        
        queryOperation.queryCompletionBlock = { cursor, error in
            if let error = error { print(error.localizedDescription); return }
            guard let cursor = cursor else { return }
            
            let secondQueryOperation = CKQueryOperation(cursor: cursor)
            secondQueryOperation.recordFetchedBlock = { record in
                self.records.append(record)
                let newBottle = Bottle(record: record)
                
                DispatchQueue.main.async {
                    if newCloudRecordIsAvailable(bottles: bottles, bottleID: newBottle.bottleID) {
                        closure(newBottle)
                    }
                }
            }
            secondQueryOperation.queryCompletionBlock = queryOperation.queryCompletionBlock
            privateCloudDatabase.add(secondQueryOperation)
        }
        
        privateCloudDatabase.add(queryOperation)
    }
    
    static func updateCloudData(bottle: Bottle, bottleImage: UIImage) {
        
        let recordID = CKRecord.ID(recordName: bottle.recordID)
        let (image, url) = prepareImageToSaveToCloud(bottle: bottle, bottleImage: bottleImage)
        guard let imageAsset = image, let imageURL = url else { return }
        
        privateCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            if let record = record, error == nil {
                DispatchQueue.main.async {
                    record.setValue(bottle.bottleDescription, forKey: "bottleDescription")
                    record.setValue(imageAsset, forKey: "bottleImage")
                    record.setValue(bottle.name, forKey: "name")
                    record.setValue(bottle.placeOfPurchase, forKey: "placeOfPurchase")
                    record.setValue(bottle.price, forKey: "price")
                    record.setValue(bottle.rating, forKey: "rating")
                    record.setValue(bottle.wineColor, forKey: "wineColor")
                    record.setValue(bottle.wineCountry, forKey: "wineCountry")
                    record.setValue(bottle.wineRegion, forKey: "wineRegion")
                    record.setValue(bottle.wineSort, forKey: "wineSort")
                    record.setValue(bottle.wineSugar, forKey: "wineSugar")
                    record.setValue(bottle.wineType, forKey: "wineType")
                    privateCloudDatabase.save(record, completionHandler: { (_, error) in
                        if let error = error { print(error.localizedDescription); return }
                        deleteTempImage(imageURL: imageURL)
                    })
                }
            }
        }
    }
    
    // Добавление картинок к загруженным из облака записям
    static func getImageFromCloud(bottle: Bottle, closure: @escaping (Data?) -> ()) {
        records.forEach { record in
            if bottle.recordID == record.recordID.recordName {
                let fetchRecordsOperation = CKFetchRecordsOperation(recordIDs: [record.recordID])
                fetchRecordsOperation.desiredKeys = ["bottleImage"]
                fetchRecordsOperation.queuePriority = .normal
                fetchRecordsOperation.perRecordCompletionBlock = { record, _, error in
                    guard error == nil else { return }
                    guard let record = record else { return }
                    guard let possibleImage = record.value(forKey: "bottleImage") as? CKAsset else { return }
                    guard let imageData = try? Data(contentsOf: possibleImage.fileURL!) else { return }
                    
                    DispatchQueue.main.async {
                        closure(imageData)
                    }
                }
                privateCloudDatabase.add(fetchRecordsOperation)
            }
        }
    }
    
    static func deleteRecord(recordID: String) {
        let query = CKQuery(recordType: "Bottle", predicate: NSPredicate(value: true))
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["recordID"]
        queryOperation.queuePriority = .veryHigh
        
        queryOperation.recordFetchedBlock = { record in
            if record.recordID.recordName == recordID {
                privateCloudDatabase.delete(withRecordID: record.recordID, completionHandler: { (_, error) in
                    if let error = error { print(error); return }
                })
            }
            
            queryOperation.queryCompletionBlock = { _, error in
                if let error = error { print(error); return }
            }
        }
        
        privateCloudDatabase.add(queryOperation)
    }
    
    private static func prepareImageToSaveToCloud(bottle: Bottle, bottleImage: UIImage) -> (CKAsset?, URL?) {
        let scale = bottleImage.size.width > 1080 ? 1080 / bottleImage.size.width : 1
        let scaleImage = UIImage(data: bottleImage.pngData()!, scale: scale)
        let imageFilePath = NSTemporaryDirectory() + bottle.date!
        let imageURL = URL(fileURLWithPath: imageFilePath)
        
        guard let dataToPath = scaleImage?.jpegData(compressionQuality: 1) else { return (nil, nil) }
        
        do {
            try dataToPath.write(to: imageURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
        let imageAsset = CKAsset(fileURL: imageURL)
        return (imageAsset, imageURL)
    }
    
    private static func deleteTempImage(imageURL: URL) {
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private static func newCloudRecordIsAvailable(bottles: Results<Bottle>, bottleID: String) -> Bool {
        for bottle in bottles {
            if bottle.bottleID == bottleID {
                return false
            }
        }
        return true
    }
}


