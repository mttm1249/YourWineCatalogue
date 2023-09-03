//
//  Persistence.swift
//  Vinishko2
//
//  Created by mttm on 28.08.2023.
//

//import CoreData
//
//struct PersistenceController {
//    static let shared = PersistenceController()
//
//    let container: NSPersistentCloudKitContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentCloudKitContainer(name: "Vinishko")
//        if inMemory {
//            container.persistentStoreDescriptions.first?.url = URL.devNull
//        }
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//    }
//}
//
//extension URL {
//    static var devNull: URL {
//        return URL(fileURLWithPath: "/dev/null")
//    }
//}


import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Vinishko")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var managedContext: NSManagedObjectContext {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension CoreDataManager {
    static func saveBottleRecord(name: String?,
                                 wineSort: [String],
                                 wineCountry: String?,
                                 wineRegion: String?,
                                 placeOfPurchase: String?,
                                 price: String?,
                                 bottleDescription: String?,
                                 wineColor: Int?,
                                 wineSugar: Int?,
                                 wineType: Int?,
                                 image: UIImage?,
                                 createDate: Date?) {
        
        let newBottle = Bottle(context: managedContext)
        newBottle.name = name
        
        // Проверка на изображение по умолчанию и сжатие
        if let defaultImage = UIImage(named: "addImage"), image != defaultImage {
            if let compressedData = image?.jpegData(compressionQuality: 0.7) {
                newBottle.bottleImage = compressedData
            }
        }
        
        // Преобразование массива вариететов вина в строку, разделенную запятыми
        newBottle.wineSort = wineSort.map( { $0.localize() } ).joined(separator: ", ")
        
        newBottle.wineCountry = wineCountry
        newBottle.wineRegion = wineRegion
        newBottle.placeOfPurchase = placeOfPurchase
        newBottle.price = price
        newBottle.bottleDescription = bottleDescription
        newBottle.wineColor = Int64(wineColor ?? 0)
        newBottle.wineSugar = Int64(wineSugar ?? 0)
        newBottle.wineType = Int64(wineType ?? 0)
        newBottle.createDate = Date()
        
        CoreDataManager.shared.saveContext()
    }
}
