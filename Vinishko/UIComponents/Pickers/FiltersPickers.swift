//
//  FiltersPickers.swift
//  Vinishko
//
//  Created by mttm on 01.10.2023.
//

import SwiftUI

enum FiltersActiveSheet: Identifiable {
    case wineSort
    case placeOfPurchase
    case wineType
    case wineCountry
    case wineRegion
    case wineSugar
    
    var id: Int {
        hashValue
    }
}

struct WineSortPicker: View {
    var wineSorts: [String]
    @Binding var selectedWineSort: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if wineSorts.isEmpty {
            Text(Localizable.FiltersPickers.grapeList)
                .padding()
                .foregroundColor(.gray)
        } else {
            CloseButton(action: {
                presentationMode.wrappedValue.dismiss()
            })
            List {
                ForEach(wineSorts.filter { !$0.isEmpty }, id: \.self) { wineSort in
                    Button(action: {
                        selectedWineSort = wineSort
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(wineSort)
                            .foregroundColor(Pallete.textColor)
                    }
                }
            }
        }
    }
}

struct WineRegionPicker: View {
    var wineRegions: [String]
    @Binding var selectedWineRegion: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if wineRegions.isEmpty {
            Text(Localizable.FiltersPickers.regionsList)
                .padding()
                .foregroundColor(.gray)
        } else {
            CloseButton(action: {
                presentationMode.wrappedValue.dismiss()
            })
            List {
                ForEach(wineRegions.filter { !$0.isEmpty }, id: \.self) { region in
                    Button(action: {
                        selectedWineRegion = region
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(region)
                            .foregroundColor(Pallete.textColor)
                    }
                }
            }
        }
    }
}

struct PlaceOfPurchasePicker: View {
    var placesOfPurchase: [String]
    @Binding var selectedPlace: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if placesOfPurchase.isEmpty {
            Text(Localizable.FiltersPickers.purchaseList)
                .padding()
                .foregroundColor(.gray)
        } else {
            CloseButton(action: {
                presentationMode.wrappedValue.dismiss()
            })
            List {
                ForEach(placesOfPurchase.filter { !$0.isEmpty }, id: \.self) { place in
                    Button(action: {
                        selectedPlace = place
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(place)
                            .foregroundColor(Pallete.textColor)
                    }
                }
            }
        }
    }
}

struct WineCountryPicker: View {
    var wineCountries: [String]
    @Binding var selectedCountry: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if wineCountries.isEmpty {
            Text(Localizable.FiltersPickers.countriesList)
                .padding()
                .foregroundColor(.gray)
        } else {
            CloseButton(action: {
                presentationMode.wrappedValue.dismiss()
            })
            List {
                ForEach(wineCountries.filter { !$0.isEmpty }, id: \.self) { country in
                    Button(action: {
                        selectedCountry = country
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(LocalizationManager.shared.getWineCountry(from: country))
                            .foregroundColor(Pallete.textColor)
                    }
                }
            }
        }
    }
}

struct WineTypePicker: View {
    var wineTypes: [Int16]
    @Binding var selectedType: Int16?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if wineTypes.isEmpty {
            Text(Localizable.FiltersPickers.typesList)
                .padding()
                .foregroundColor(.gray)
        } else {
            CloseButton(action: {
                presentationMode.wrappedValue.dismiss()
            })
            List {
                ForEach(wineTypes, id: \.self) { name in
                    Button(action: {
                        selectedType = name
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(LocalizationManager.shared.getWineType(name))
                            .foregroundColor(Pallete.textColor)
                    }
                }
            }
        }
    }
}

struct WineSugarPicker: View {
    var wineSugarAmount: [Int16]
    @Binding var selectedSugarAmount: Int16?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if wineSugarAmount.isEmpty {
            Text(Localizable.FiltersPickers.sugarAmountList)
                .padding()
                .foregroundColor(.gray)
        } else {
            CloseButton(action: {
                presentationMode.wrappedValue.dismiss()
            })
            List {
                ForEach(wineSugarAmount, id: \.self) { amount in
                    Button(action: {
                        selectedSugarAmount = amount
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(LocalizationManager.shared.getWineSugar(amount))
                            .foregroundColor(Pallete.textColor)
                    }
                }
            }
        }
    }
}
