//
//  MigrationService.swift
//  Vinishko
//
//  Created by mttm on 03.09.2023.
//


import UIKit
import CloudKit

class MigrationService {
    private static let privateCloudDatabase = CKContainer(identifier: "iCloud.userContainer.Vinishko").privateCloudDatabase
    private static var records: [CKRecord] = []
    
    static func performInitialMigration() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "InitialMigrationPerformed") {
            fetchDataFromCloud()
            defaults.set(true, forKey: "InitialMigrationPerformed")
        }
    }
    
    static private func convertStringToDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        let date = dateFormatter.date(from: dateString)
        print("Converted Date: \(String(describing: date))")
        return date
    }
    
    static private func fetchDataFromCloud() {
        let query = CKQuery(recordType: "Bottle", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.recordFetchedBlock = { record in
            // Добавляем запись в массив
            self.records.append(record)
            
            // Извлекаем данные из CKRecord и сохраняем в CoreData
            let name = record["name"] as? String
            let wineSort = (record["wineSort"] as? String)?.components(separatedBy: ", ") ?? []
            let wineCountry = record["wineCountry"] as? String
            let wineRegion = record["wineRegion"] as? String
            let placeOfPurchase = record["placeOfPurchase"] as? String
            let price = record["price"] as? String
            let rating = record["rating"] as? Int
            let bottleDescription = record["bottleDescription"] as? String
            let wineColor = record["wineColor"] as? Int
            let wineSugar = record["wineSugar"] as? Int
            let wineType = record["wineType"] as? Int
            let date = record["date"] as? String
            
            var uiImage: UIImage? = nil
            if let asset = record["bottleImage"] as? CKAsset, let data = try? Data(contentsOf: asset.fileURL!), let image = UIImage(data: data) {
                uiImage = image
            }
            
            // Сохраняем в CoreData
            CoreDataManager.saveBottleRecord(name: name,
                                             wineSort: wineSort,
                                             wineCountry: wineCountry,
                                             wineRegion: wineRegion,
                                             placeOfPurchase: placeOfPurchase,
                                             price: price,
                                             rating: rating,
                                             bottleDescription: bottleDescription,
                                             wineColor: wineColor,
                                             wineSugar: wineSugar,
                                             wineType: wineType,
                                             image: uiImage,
                                             createDate: convertStringToDate(date),
                                             isOldRecord: true,
                                             doubleRating: Double(rating ?? 0))
            
        }
        privateCloudDatabase.add(queryOperation)
    }
}
