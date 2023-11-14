//
//  NewBottleViewModel.swift
//  Vinishko
//
//  Created by mttm on 05.10.2023.
//

import SwiftUI
import CoreData

class NewBottleViewModel: ObservableObject {
    
    var onBottleSaved: ((Bottle) -> Void)?
    
    @Published var bottleName: String = ""
    @Published var selectedGrapeVarieties: [String] = []
    @Published var selectedCountry: Country?
    @Published var selectedRegion: String?
    @Published var placeOfPurchase: String = ""
    @Published var price: String = ""
    @Published var bottleDescription: String = ""
    @Published var colorSelectedSegment = 0
    @Published var sugarSelectedSegment = 0
    @Published var typeSelectedSegment = 0
    @Published var rating: Double = 0
    @Published var image: UIImage = UIImage(named: "addImage") ?? UIImage()
    @Published var showingQRScanner = false
    @Published var scannedCode: String?

    @Published var editableBottle: Bottle?
    
    private var managedObjectContext: NSManagedObjectContext
    
    init(editableBottle: Bottle?, context: NSManagedObjectContext, onBottleSaved: ((Bottle) -> Void)? = nil) {
        self.onBottleSaved = onBottleSaved
        self.editableBottle = editableBottle
        self.managedObjectContext = context
        loadBottleDetails()
    }
    
    func loadBottleDetails() {
        guard let editableBottle = editableBottle else { return }
        
        if let imageData = editableBottle.bottleImage {
            image = UIImage(data: imageData) ?? UIImage()
        } else {
            image = UIImage()
        }
        
        rating = editableBottle.doubleRating
        bottleName = editableBottle.name ?? ""
        colorSelectedSegment = Int(editableBottle.wineColor)
        sugarSelectedSegment = Int(editableBottle.wineSugar)
        typeSelectedSegment =  Int(editableBottle.wineType)
        selectedGrapeVarieties = editableBottle.wineSort?.components(separatedBy: ", ") ?? []
        let country = Country(code: editableBottle.wineCountry ?? "", regions: [])
        selectedCountry = country
        selectedRegion = editableBottle.wineRegion
        placeOfPurchase = editableBottle.placeOfPurchase ?? ""
        price = editableBottle.price ?? ""
        bottleDescription = editableBottle.bottleDescription ?? ""
    }
    
    func save() {
        if let editableBottle = editableBottle {
            // Редактирование существующей записи
            
            // Проверяем, изменилось ли изображение
            if let currentImageData = editableBottle.bottleImage,
               let newImageData = image.jpegData(compressionQuality: 1.0) {
                
                // Сравниваем данные текущего изображения и нового изображения
                if !currentImageData.elementsEqual(newImageData) {
                    // Если изображения различаются, сохраняем новое изображение
                    editableBottle.bottleImage = newImageData
                }
            }
            
            editableBottle.name = bottleName
            editableBottle.wineSort = selectedGrapeVarieties.joined(separator: ", ")
            editableBottle.wineCountry = checkCountryCode(selectedCountry)
            editableBottle.wineRegion = checkRegion(selectedRegion)
            editableBottle.placeOfPurchase = placeOfPurchase
            editableBottle.price = price
            editableBottle.bottleDescription = bottleDescription
            editableBottle.wineColor = Int16(colorSelectedSegment)
            editableBottle.wineSugar = Int16(sugarSelectedSegment)
            editableBottle.wineType = Int16(typeSelectedSegment)
            editableBottle.doubleRating = rating
            
            CoreDataManager.shared.saveContext()
            
            // update bottle details
            onBottleSaved?(editableBottle)
            
            HapticFeedbackService.generateFeedback(style: .medium)
        } else {
            CoreDataManager.saveBottleRecord(
                name: bottleName,
                wineSort: selectedGrapeVarieties,
                wineCountry: checkCountryCode(selectedCountry),
                wineRegion: checkRegion(selectedRegion),
                placeOfPurchase: placeOfPurchase,
                price: price,
                rating: 0,
                bottleDescription: bottleDescription,
                wineColor: colorSelectedSegment,
                wineSugar: sugarSelectedSegment,
                wineType: typeSelectedSegment,
                image: image,
                createDate: Date(),
                isOldRecord: false,
                doubleRating: rating
            )
            NotificationCenter.default.post(name: .didSaveBottleNotification, object: nil)
            HapticFeedbackService.generateFeedback(style: .success)
        }
    }
    
    // exclude empty records when filtering
    func checkCountryCode(_ selectedCountry: Country?) -> String {
        return selectedCountry?.code ?? ""
    }
    
    func checkRegion(_ selectedRegion: String?) -> String {
        return selectedRegion ?? ""
    }
}
