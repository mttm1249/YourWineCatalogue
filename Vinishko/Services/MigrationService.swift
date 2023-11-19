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
    
    static func checkForExistingRecords(completion: @escaping (Bool) -> Void) {
        let query = CKQuery(recordType: "Bottle", predicate: NSPredicate(value: true))
        let queryOperation = CKQueryOperation(query: query)

        var recordsExist = false

        queryOperation.recordMatchedBlock = { (recordID, result) in
            switch result {
            case .success(_):
                // Если найдена хотя бы одна запись, устанавливаем флаг
                recordsExist = true
            case .failure(let error):
                print("Error fetching record: \(error)")
            }
        }

        queryOperation.queryResultBlock = { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    // Вызываем completion с true, если найдены записи
                    completion(recordsExist)
                case .failure(let error):
                    print("Error completing query: \(error)")
                    completion(false)
                }
            }
        }

        privateCloudDatabase.add(queryOperation)
    }


    static func performInitialMigration(userCancelled: Bool = false, completion: ((Bool) -> Void)? = nil) {
        let defaults = UserDefaults.standard

        // Проверяем, была ли миграция уже выполнена или пользователь отменил её
        if defaults.bool(forKey: "InitialMigrationPerformed") || defaults.bool(forKey: "UserDeclinedMigration") {
            return
        }

        // Если пользователь отменил миграцию, устанавливаем соответствующий флаг
        if userCancelled {
            defaults.set(true, forKey: "UserDeclinedMigration")
            return
        }

        checkForExistingRecords { exists in
            DispatchQueue.main.async {
                if exists {
                    // Записи есть, нужно показать alert
                    completion?(true)
                } else {
                    // Записей нет, делаем миграцию и устанавливаем флаг
                    fetchDataFromCloud()
                    defaults.set(true, forKey: "InitialMigrationPerformed")
                    completion?(false)
                }
            }
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
