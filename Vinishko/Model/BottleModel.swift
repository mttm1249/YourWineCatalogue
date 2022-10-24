//
//  BottleModel.swift
//  Vinishko
//
//  Created by Денис on 01.10.2022.
//

import UIKit
import RealmSwift

class Bottle: Object {
    @Persisted var bottleImage: Data?
    @Persisted var wineColor: Int?
    @Persisted var wineType: Int?
    @Persisted var wineSugar: Int?
    @Persisted var name: String?
    @Persisted var bottleDescription: String?
    @Persisted var placeOfPurchase: String?
    @Persisted var wineCountry: String?
    @Persisted var wineSort: String?
    @Persisted var wineRegion: String?
    @Persisted var price: String?
    @Persisted var date: String?
    @Persisted var rating = 0
    
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
}
