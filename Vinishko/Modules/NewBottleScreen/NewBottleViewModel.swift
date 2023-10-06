//
//  NewBottleViewModel.swift
//  Vinishko
//
//  Created by mttm on 05.10.2023.
//

import SwiftUI
import Combine

class NewBottleViewModel: ObservableObject {
    @Published var image: UIImage = UIImage(named: "addImage") ?? UIImage()
    @Published var rating: Double = 0
    @Published var bottleName: String = ""
    @Published var placeOfPurchase: String = ""
    @Published var price: String = ""
    @Published var bottleDescription: String = ""
    @Published var colorSelectedSegment = 0
    @Published var sugarSelectedSegment = 0
    @Published var typeSelectedSegment = 0
    @Published var selectedCountry: Country?
    @Published var selectedRegion: String?
    @Published var selectedGrapeVarieties: [String] = []
    
    var editableBottle: Bottle?
    
    init(editableBottle: Bottle?) {
        self.editableBottle = editableBottle
        loadEditableBottleData()
    }
    
    func loadEditableBottleData() {
        guard let editableBottle = editableBottle else { return }
        
        if let imageData = editableBottle.bottleImage {
            image = UIImage(data: imageData) ?? UIImage()
        }
        
        rating = editableBottle.doubleRating
        bottleName = editableBottle.name ?? ""
        colorSelectedSegment = Int(editableBottle.wineColor)
        sugarSelectedSegment = Int(editableBottle.wineSugar)
        typeSelectedSegment = Int(editableBottle.wineType)
        selectedGrapeVarieties.append(editableBottle.wineSort ?? "")
        let country = Country(code: editableBottle.wineCountry ?? "", regions: [])
        selectedCountry = country
        selectedRegion = editableBottle.wineRegion
        placeOfPurchase = editableBottle.placeOfPurchase ?? ""
        price = editableBottle.price ?? ""
        bottleDescription = editableBottle.bottleDescription ?? ""
    }
    
    func saveOrUpdateBottle() {
        if let editableBottle = editableBottle {
//            updateBottle(editableBottle)
        } else {
            saveBottle()
        }
    }
    
//    private func updateBottle(_ bottle: Bottle) {
//        bottle.name = bottleName
//
//        CoreDataManager.shared.saveContext()
//    }
    
    private func saveBottle() {
        // Your code to save a new bottle
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
    }
    
    func checkCountryCode(_ selectedCountry: Country?) -> String {
        if let countryCode = selectedCountry?.code {
            return countryCode
        } else {
            return ""
        }
    }
    
    func checkRegion(_ selectedRegion: String?) -> String {
        if let region = selectedRegion {
            return region
        } else {
            return ""
        }
    }
}
