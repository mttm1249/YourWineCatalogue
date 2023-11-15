//
//  QRModel.swift
//  Vinishko
//
//  Created by mttm on 14.11.2023.
//

import Foundation

struct QRModel: Decodable {
    let verification: String
    let rating: Double
    let imageURL: String
    let name: String
    let wineColor: Int
    let wineSugar: Int
    let wineType: Int
    let wineSort: String
    let wineCountry: String
    let wineRegion: String
    let placeOfPurchase: String
    let price: String
    let bottleDescription: String
}
