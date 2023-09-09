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
                                 rating: Int?,
                                 bottleDescription: String?,
                                 wineColor: Int?,
                                 wineSugar: Int?,
                                 wineType: Int?,
                                 image: UIImage?,
                                 createDate: Date?,
                                 isOldRecord: Bool,
                                 doubleRating: Double?) {
        
        let newBottle = Bottle(context: managedContext)
        
        newBottle.name = name
        processWineSortFor(newBottle, with: wineSort)
        newBottle.wineCountry = wineCountry
        newBottle.wineRegion = wineRegion
        newBottle.placeOfPurchase = placeOfPurchase
        newBottle.price = price
        newBottle.rating = Int64(rating ?? 0)
        newBottle.bottleDescription = bottleDescription
        newBottle.wineColor = Int64(wineColor ?? 0)
        newBottle.wineSugar = Int64(wineSugar ?? 0)
        newBottle.wineType = Int64(wineType ?? 0)
        processImageFor(newBottle, with: image)
        newBottle.createDate = Date()
        newBottle.isOldRecord = isOldRecord
        newBottle.doubleRating = doubleRating ?? 0.0
        
        CoreDataManager.shared.saveContext()
    }
    
    private static func processImageFor(_ bottle: Bottle, with image: UIImage?) {
        if let defaultImage = UIImage(named: "addImage"), image != defaultImage,
           let compressedData = image?.jpegData(compressionQuality: 0.8) {
            bottle.bottleImage = compressedData
        }
    }
    
    private static func processWineSortFor(_ bottle: Bottle, with wineSort: [String]) {
        bottle.wineSort = wineSort.map( { $0.localize() } ).joined(separator: ", ")
    }
}
