//
//  CoreDataManager.swift
//  Vinishko
//
//  Created by mttm on 28.08.2023.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
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

// New function for checking if a record exists with the given name
extension CoreDataManager {
    static func recordExists(withName name: String?) -> Bool {
        guard let nameToCheck = name else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bottle")
        fetchRequest.predicate = NSPredicate(format: "name == %@", nameToCheck)
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("Error occurred while executing fetch request: \(error)")
            return false
        }
    }
}

// Modified function to include the check for existing record
extension CoreDataManager {
    static func saveBottleRecord(name: String?,
                                 wineSort: [String],
                                 wineCountry: String?,
                                 wineRegion: String?,
                                 placeOfPurchase: String?,
                                 price: String?,
                                 rating: Int?,
                                 bottleDescription: String?,
                                 wineColor: Int?,
                                 wineSugar: Int?,
                                 wineType: Int?,
                                 image: UIImage?,
                                 createDate: Date?,
                                 isOldRecord: Bool,
                                 doubleRating: Double?) {
        
        // If a record with the same name already exists, return without saving
        if recordExists(withName: name) {
            print("Record with the same name already exists. Skipping the save operation.")
            return
        }
        
        let newBottle = Bottle(context: managedContext)
        
        newBottle.name = name
        newBottle.wineSort = wineSort.joined(separator: ", ")
        newBottle.wineCountry = wineCountry
        newBottle.wineRegion = wineRegion
        newBottle.placeOfPurchase = placeOfPurchase
        newBottle.price = price
        newBottle.rating = Int16(rating ?? 0)
        newBottle.bottleDescription = bottleDescription
        newBottle.wineColor = Int16(wineColor ?? 0)
        newBottle.wineSugar = Int16(wineSugar ?? 0)
        newBottle.wineType = Int16(wineType ?? 0)
        newBottle.createDate = createDate
        newBottle.isOldRecord = isOldRecord
        newBottle.doubleRating = doubleRating ?? 0.0
        
        if let imageToSave = image, let imageData = imageToSave.jpegData(compressionQuality: 0.8) {
            newBottle.bottleImage = imageData
        }
        
        CoreDataManager.shared.saveContext()
    }
}
