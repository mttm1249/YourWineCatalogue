//
//  QRGenerator.swift
//  Vinishko
//
//  Created by Денис on 26.01.2023.
//

import UIKit

class QRGenerator {
    static func generateQR(imageURL: String,
                           name: String,
                           wineColor: Int,
                           wineSugar: Int,
                           wineType: Int,
                           wineSort: String,
                           wineCountry: String,
                           wineRegion: String,
                           placeOfPurchase: String,
                           price: String,
                           bottleDescription: String,
                           rating: Int) -> UIImage? {
        var jsonDict = [String: Any]()
        jsonDict.updateValue("VinishkoAPP", forKey: "verification")
        jsonDict.updateValue(imageURL, forKey: "imageURL")
        jsonDict.updateValue(name, forKey: "name")
        jsonDict.updateValue(wineColor, forKey: "wineColor")
        jsonDict.updateValue(wineSugar, forKey: "wineSugar")
        jsonDict.updateValue(wineType, forKey: "wineType")
        jsonDict.updateValue(wineSort, forKey: "wineSort")
        jsonDict.updateValue(wineCountry, forKey: "wineCountry")
        jsonDict.updateValue(wineRegion, forKey: "wineRegion")
        jsonDict.updateValue(placeOfPurchase, forKey: "placeOfPurchase")
        jsonDict.updateValue(bottleDescription, forKey: "bottleDescription")
        jsonDict.updateValue(price, forKey: "price")
        jsonDict.updateValue(rating, forKey: "rating")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [.prettyPrinted])
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(jsonData, forKey: "InputMessage")
        let transform = CGAffineTransform(scaleX: 12, y: 12)
        if let output = filter?.outputImage?.transformed (by: transform) {
            return UIImage(ciImage: output)
        }
        return nil
    }
}
