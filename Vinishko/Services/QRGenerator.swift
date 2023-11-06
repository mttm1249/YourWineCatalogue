//
//  QRGenerator.swift
//  Vinishko
//
//  Created by mttm on 06.11.2023.
//

import UIKit
import CoreImage.CIFilterBuiltins

class QRGenerator {
    
//    @IBAction func generateAction(_ sender: Any) {
//        progressView.isHidden = false
//        
//        // Upload image to Firebase
//        let randomID = UUID.init().uuidString
//        let uploadRef = Storage.storage().reference(withPath: "images/\(randomID).jpg")
//        guard let imageData = bottleImage.image?.jpegData(compressionQuality: 0.3) else { return }
//        
//        let uploadMetadata = StorageMetadata.init()
//        uploadMetadata.contentType = "image/jpg"
//        
//        let taskReference = uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
//            if let error = error {
//                print("Oh no! Got an error! \(error.localizedDescription)")
//                return
//            }
//            uploadRef.downloadURL(completion: { (url, error) in
//                if let error = error {
//                    print("Got an error generating URL: \(error.localizedDescription)")
//                    return
//                }
//                if let url = url {
//                    self.imageURL = url.absoluteString
//                }
//            })
//        }
//        // ProgressView
//        taskReference.observe(.progress) { [weak self] (snapshot) in
//            guard let progressValue = snapshot.progress?.fractionCompleted else { return }
//            self?.progressView.progress = Float(progressValue)
//        }
//    }
//    
//    private func checkPermissionForSharing(by key: String, value: String) -> String {
//        let result = userDefaults.bool(forKey: key)
//        if result == true {
//            return value
//        }
//        return ""
//    }
//    
//    private func checkPermissionForSharingRating(by key: String, value: Int) -> Int {
//        let result = userDefaults.bool(forKey: key)
//        if result == true {
//            return value
//        }
//        return 0
//    }
//    
//    private func generateQR(with imageURL: String) {
//        // Converting JSON string to UIImage
//        qrImage = QRGenerator.generateQR(imageURL: checkPermissionForSharing(by: "shareImage", value: imageURL),
//                                         name: currentBottle.name!,
//                                         wineColor: currentBottle.wineColor!,
//                                         wineSugar: currentBottle.wineSugar!,
//                                         wineType: currentBottle.wineType!,
//                                         wineSort: currentBottle.wineSort!,
//                                         wineCountry: currentBottle.wineCountry!,
//                                         wineRegion: currentBottle.wineRegion!,
//                                         placeOfPurchase: currentBottle.placeOfPurchase!,
//                                         price: currentBottle.price!,
//                                         bottleDescription: checkPermissionForSharing(by: "shareComment", value: currentBottle.bottleDescription!),
//                                         rating: checkPermissionForSharingRating(by: "shareRating", value: currentBottle.rating)) ?? UIImage()
//    }
//    
    
    
    
    
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
        jsonDict["verification"] = "VinishkoAPP"
        jsonDict["imageURL"] = imageURL
        jsonDict["name"] = name
        jsonDict["wineColor"] = wineColor
        jsonDict["wineSugar"] = wineSugar
        jsonDict["wineType"] = wineType
        jsonDict["wineSort"] = wineSort
        jsonDict["wineCountry"] = wineCountry
        jsonDict["wineRegion"] = wineRegion
        jsonDict["placeOfPurchase"] = placeOfPurchase
        jsonDict["bottleDescription"] = bottleDescription
        jsonDict["price"] = price
        jsonDict["rating"] = rating
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict),
              let jsonString = String(data: jsonData, encoding: .utf8),
              let data = jsonString.data(using: .isoLatin1, allowLossyConversion: false) else {
            return nil
        }

        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        filter.correctionLevel = "H"

        guard let outputImage = filter.outputImage else { return nil }
        let scale = CGAffineTransform(scaleX: 12, y: 12)
        let scaledImage = outputImage.transformed(by: scale)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
