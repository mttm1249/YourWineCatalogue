//
//  BottleModel.swift
//  Vinishko
//
//  Created by mttm on 28.08.2023.
//

import Foundation

struct BottleModel {
    var name: String?
    var bottleDescription: String?
    var placeOfPurchase: String?
    var wineCountry: String?
    var wineSort: String?
    var wineRegion: String?
    var price: String?
    var date: String?
    var rating = 0
    var bottleImage: Data?
    var wineColor: Int?
    var wineType: Int?
    var wineSugar: Int?
    
    init(name: String,
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

