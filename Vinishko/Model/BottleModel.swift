//
//  BottleModel.swift
//  Vinishko
//
//  Created by Денис on 01.10.2022.
//

import RealmSwift
import CloudKit
import UIKit

class Bottle: Object {
    @Persisted var bottleID = UUID().uuidString
    @Persisted var recordID = ""
    @Persisted var name: String?
    @Persisted var bottleDescription: String?
    @Persisted var placeOfPurchase: String?
    @Persisted var wineCountry: String?
    @Persisted var wineSort: String?
    @Persisted var wineRegion: String?
    @Persisted var price: String?
    @Persisted var date: String?
    @Persisted var rating = 0
    @Persisted var bottleImage: Data?
    @Persisted var wineColor: Int?
    @Persisted var wineType: Int?
    @Persisted var wineSugar: Int?
    
    convenience init(name: String,
                     bottleDescription: String?,
                     placeOfPurchase: String?,
                     date: String?,
                     bottleImage: Data?,
                     rating: Int,
                     wineRegion: String?,
                     price: String?,
                     wineColor: Int?,
                     wineType: Int?,
                     wineSugar: Int?,
                     wineSort: String?,
                     wineCountry: String?)
    {
        
        self.init()
        self.date = date
        self.name = name
        self.bottleDescription = bottleDescription
        self.placeOfPurchase = placeOfPurchase
        self.bottleImage = bottleImage
        self.rating = rating
        self.wineRegion = wineRegion
        self.price = price
        self.wineColor = wineColor
        self.wineType = wineType
        self.wineSugar = wineSugar
        self.wineSort = wineSort
        self.wineCountry = wineCountry
    }
    
    convenience init(record: CKRecord) {
        self.init()
        
        let image = UIImage(named: "noimage")
        let imageData = image?.pngData()
        
        self.bottleID = record.value(forKey: "bottleID") as! String
        self.recordID = record.recordID.recordName
        self.bottleImage = imageData
        self.name = record.value(forKey: "name") as? String
        self.bottleDescription = record.value(forKey: "bottleDescription") as? String
        self.placeOfPurchase = record.value(forKey: "placeOfPurchase") as? String
        self.rating = record.value(forKey: "rating") as! Int
        self.wineRegion = record.value(forKey: "wineRegion") as? String
        self.price = record.value(forKey: "price") as? String
        self.date = record.value(forKey: "date") as? String
        self.wineColor = record.value(forKey: "wineColor") as? Int
        self.wineType = record.value(forKey: "wineType") as? Int
        self.wineSugar = record.value(forKey: "wineSugar") as? Int
        self.wineSort = record.value(forKey: "wineSort") as? String
        self.wineCountry = record.value(forKey: "wineCountry") as? String
    }
    
    static override func primaryKey() -> String? {
        return "bottleID"
    }
}
