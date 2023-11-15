//
//  QRModel.swift
//  Vinishko
//
//  Created by mttm on 14.11.2023.
//

import Foundation

struct QRModel: Decodable {
    let name: String
    let wineColor: Int
    let wineSugar: Int
    let wineType: Int
    let wineSort: String
    let wineCountry: String
    let wineRegion: String
    let placeOfPurchase: String
    let price: String
    var imageURL: String?
    var rating: Double?
    var bottleDescription: String?
}
