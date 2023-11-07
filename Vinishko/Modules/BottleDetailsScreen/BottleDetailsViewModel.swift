//
//  BottleDetailsViewModel.swift
//  Vinishko
//
//  Created by mttm on 15.09.2023.
//

import SwiftUI

final class BottleDetailsViewModel: ObservableObject {
    
    var bottle: Bottle
    @Published var qrCodeImage: UIImage?
    @Published var isUploading: Bool = false
    
    init(bottle: Bottle) {
        self.bottle = bottle
    }
    
    private func generateQRCode(with imageURL: String) {
            self.qrCodeImage = QRGenerator.generateQR(imageURL: imageURL,
                                                      name: self.bottle.name ?? "",
                                                      wineColor: Int(self.bottle.wineColor),
                                                      wineSugar: Int(self.bottle.wineSugar),
                                                      wineType: Int(self.bottle.wineType),
                                                      wineSort: self.bottle.wineSort ?? "",
                                                      wineCountry: self.bottle.wineCountry ?? "",
                                                      wineRegion: self.bottle.wineRegion ?? "",
                                                      placeOfPurchase: self.bottle.placeOfPurchase ?? "",
                                                      price: self.bottle.price ?? "",
                                                      bottleDescription: self.bottle.bottleDescription ?? "",
                                                      rating: self.bottle.doubleRating)
    }
    
    func uploadImageAndGenerateQRCode(imageData: Data?) {
        guard let imageData = imageData else {
            print("Ошибка: изображение отсутствует.")
            self.generateQRCode(with: "")
            return
        }
        
        isUploading = true
        
        QRGenerator.upload(imageData: imageData) { [weak self] (urlString, error) in
            self?.isUploading = false
            if let error = error {
                print("Ошибка при загрузке: \(error.localizedDescription)")
            } else if let urlString = urlString {
                self?.generateQRCode(with: urlString)
                print("URL изображения: \(urlString)")
            }
        }
    }
    
    func updateBottle(_ newBottle: Bottle) {
        self.bottle = newBottle
        self.objectWillChange.send()
    }
    
    func getWineColor(for bottle: Bottle) -> Color {
        switch bottle.wineColor {
        case 0:
            return Pallete.redWineColor
        case 1:
            return Pallete.whiteWineColor
        case 2:
            return Pallete.otherWineColor
        default:
            return .clear
        }
    }
    
    func getWineColorName(for bottle: Bottle) -> String {
        switch bottle.wineColor {
        case 0:
            return "Красное"
        case 1:
            return "Белое"
        case 2:
            return "Другое"
        default:
            return ""
        }
    }
    
    func getWineSugar(for bottle: Bottle) -> String {
        switch bottle.wineSugar {
        case 0:
            return "Сухое"
        case 1:
            return "Полусухое"
        case 2:
            return "Полусладкое"
        case 3:
            return "Сладкое"
        default:
            return ""
        }
    }
    
    func getWineType(for bottle: Bottle) -> String {
        switch bottle.wineType {
        case 0:
            return "Тихое"
        case 1:
            return "Игристое"
        case 2:
            return "Другое"
        default:
            return ""
        }
    }
    
    func getCreateDateString(bottle: Bottle) -> String {
        guard let unwrappedDate = bottle.createDate else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        return dateFormatter.string(from: unwrappedDate)
    }
}
