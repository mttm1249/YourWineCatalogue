//
//  QRGenerator.swift
//  Vinishko
//
//  Created by mttm on 06.11.2023.
//

import UIKit
import CoreImage.CIFilterBuiltins
import FirebaseStorage

final class QRGenerator {
    
    static func setDefaultQRSettings() {
        let defaults = UserDefaults.standard
        let keys = [UserDefaultsKey.photoShare.rawValue, UserDefaultsKey.ratingShare.rawValue, UserDefaultsKey.commentShare.rawValue]
        
        if defaults.bool(forKey: "isFirstLaunch") == false {
            defaults.set(true, forKey: "isFirstLaunch")
            
            keys.forEach { key in
                defaults.set(true, forKey: key)
            }
        }
    }

    static func upload(imageData: Data?, completion: @escaping (String?, Error?) -> Void) {
        guard let unwrappedImageData = imageData else {
            completion(nil, NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Изображение отсутствует или данные некорректны."]))
            return
        }
        
        guard let image = UIImage(data: unwrappedImageData) else {
            completion(nil, NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось преобразовать Data в UIImage."]))
            return
        }
        
        guard let compressedImageData = image.jpegData(compressionQuality: 0.2) else {
            completion(nil, NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось сжать изображение."]))
            return
        }
        
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "images2/\(randomID).jpg")
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        uploadRef.putData(compressedImageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            uploadRef.downloadURL { (url, error) in
                if let error = error {
                    completion(nil, error)
                } else if let url = url {
                    completion(url.absoluteString, nil)
                }
            }
        }
    }
    
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
                           rating: Double) -> UIImage? {
        
        let userDefaults = UserDefaults.standard
        var jsonDict = [String: Any]()
        
        jsonDict["name"] = name
        jsonDict["wineColor"] = wineColor
        jsonDict["wineSugar"] = wineSugar
        jsonDict["wineType"] = wineType
        jsonDict["wineSort"] = wineSort
        jsonDict["wineCountry"] = wineCountry
        jsonDict["wineRegion"] = wineRegion
        jsonDict["placeOfPurchase"] = placeOfPurchase
        jsonDict["price"] = price
        
        // Проверка разрешений в UserDefaults и добавление данных в QR код
        if userDefaults.bool(forKey: UserDefaultsKey.photoShare.rawValue) {
            jsonDict["imageURL"] = imageURL
        }
        if userDefaults.bool(forKey: UserDefaultsKey.ratingShare.rawValue) {
            jsonDict["rating"] = rating
        }
        if userDefaults.bool(forKey: UserDefaultsKey.commentShare.rawValue) {
            jsonDict["bottleDescription"] = bottleDescription
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else {
            print("Ошибка при создании JSON")
            return nil
        }
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            print("Ошибка при создании CIFilter")
            return nil
        }
        
        filter.setValue(jsonData, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        let transform = CGAffineTransform(scaleX: 15, y: 15)
        
        if let output = filter.outputImage?.transformed(by: transform) {
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
