//
//  FiltersView.swift
//  Vinishko
//
//  Created by mttm on 29.08.2023.
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
            Text("Список сортов пуст")
                .padding()
                .foregroundColor(.gray)
        } else {
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
            Text("Список регионов пуст")
                .padding()
                .foregroundColor(.gray)
        } else {
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
            Text("Список мест пуст")
                .padding()
                .foregroundColor(.gray)
        } else {
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
            Text("Список стран пуст")
                .padding()
                .foregroundColor(.gray)
        } else {
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
            Text("Список типов пуст")
                .padding()
                .foregroundColor(.gray)
        } else {
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
            Text("Список содержания сахара пуст")
                .padding()
                .foregroundColor(.gray)
        } else {
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

struct FiltersView: View {
    @EnvironmentObject var viewModel: BottlesCatalogueViewModel
    @State private var selectedWineSort: String? = nil
    @State private var selectedWineSugarAmount: Int16? = nil
    @State private var selectedWineCountry: String? = nil
    @State private var selectedWineRegion: String? = nil
    @State private var selectedPlaceOfPurchase: String? = nil
    @State private var selectedWineType: Int16? = nil
    @State private var selectedPicker: FiltersActiveSheet?
    @State private var showingPicker = false
    @State private var selectedSorting = 0
    
    var body: some View {
        VStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Сортировать по")
                        .font(.system(size: 14)).bold()
                        .foregroundColor(.gray)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                    SegmentedPicker(titles: ["Дате", "Рейтингу", "Цене"], selectedSegment: $selectedSorting)
                        .onChange(of: selectedSorting) { newValue in
                            selectedSorting = newValue
                        }
                }
                
            FilterButton(header: "По содержанию сахара", filterType: .wineSugarInt($selectedWineSugarAmount)) {
                selectedPicker = .wineSugar
                showingPicker = true
            }
            .onChange(of: selectedWineSugarAmount) { newValue in
                selectedWineSugarAmount = newValue
            }
            
                FilterButton(header: "По типу", filterType: .wineTypeInt($selectedWineType)) {
                    selectedPicker = .wineType
                    showingPicker = true
                }
                .onChange(of: selectedWineType) { newValue in
                    selectedWineType = newValue
                }
                
                FilterButton(header: "По сорту", filterType: .string($selectedWineSort)) {
                    selectedPicker = .wineSort
                    showingPicker = true
                }
                .onChange(of: selectedWineSort) { newValue in
                    selectedWineSort = newValue
                }
                
            FilterButton(header: "По стране", filterType: .countryCode($selectedWineCountry)) {
                selectedPicker = .wineCountry
                showingPicker = true
            }
            .onChange(of: selectedWineCountry) { newValue in
                selectedWineCountry = newValue
            }
              
            FilterButton(header: "По региону", filterType: .string($selectedWineRegion)) {
                selectedPicker = .wineRegion
                showingPicker = true
            }
            .onChange(of: selectedWineRegion) { newValue in
                selectedWineRegion = newValue
            }
                                
                FilterButton(header: "По месту покупки", filterType: .string($selectedPlaceOfPurchase)) {
                    selectedPicker = .placeOfPurchase
                    showingPicker = true
                }
                .onChange(of: selectedPlaceOfPurchase) { newValue in
                    selectedPlaceOfPurchase = newValue
                }
                
                Spacer()
                
                Button(action: {
                    HapticFeedbackService.generateFeedback(style: .success)
                    // Сбрасываем значения фильтров
                    selectedWineSort = nil
                    selectedWineType = nil
                    selectedSorting = 0
                    selectedWineCountry = nil
                    selectedWineRegion = nil
                    selectedWineSugarAmount = nil
                    selectedPlaceOfPurchase = nil
                    viewModel.selectedWineSort = nil
                    viewModel.selectedPlace = nil
                    viewModel.selectedType = nil
                    viewModel.selectedSorting = 0
                    viewModel.selectedWineCountry = nil
                    viewModel.selectedWineRegion = nil
                    viewModel.selectedWineSugar = nil
                }) {
                    Text("Сбросить")
                        .foregroundColor(.red)
                }
            .navigationTitle("Сортировка и фильтры")
            .sheet(item: $selectedPicker) { item in
                switch item {
                case .wineSort:
                    let allAvailableSorts = viewModel.wineSorts.flatMap { $0.split(separator: ",").map(String.init) }.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                    WineSortPicker(wineSorts: Array(Set(allAvailableSorts)).sorted(), selectedWineSort: $selectedWineSort)
                case .placeOfPurchase:
                    let allAvailablePurchasePlaces = viewModel.placesOfPurchase
                    PlaceOfPurchasePicker(placesOfPurchase: allAvailablePurchasePlaces, selectedPlace: $selectedPlaceOfPurchase)
                case .wineType:
                    let allAvailableTypes = viewModel.wineTypes
                    WineTypePicker(wineTypes: allAvailableTypes, selectedType: $selectedWineType)
                case .wineCountry:
                    let allAvailableCountries = viewModel.wineCountries
                    WineCountryPicker(wineCountries: allAvailableCountries, selectedCountry: $selectedWineCountry)
                case .wineRegion:
                    let allAvailableRegions = viewModel.wineRegions
                    WineRegionPicker(wineRegions: allAvailableRegions, selectedWineRegion: $selectedWineRegion)
                case .wineSugar:
                    let allAvailableSugar = viewModel.wineSugar
                    WineSugarPicker(wineSugarAmount: allAvailableSugar, selectedSugarAmount: $selectedWineSugarAmount)
                }
            }
            .onAppear {
                if selectedWineSort == nil {
                    selectedWineSort = viewModel.selectedWineSort
                }
                if selectedPlaceOfPurchase == nil {
                    selectedPlaceOfPurchase = viewModel.selectedPlace
                }
                if selectedWineType == nil {
                    selectedWineType = viewModel.selectedType
                }
                if selectedSorting == 0 {
                    selectedSorting = viewModel.selectedSorting
                }
                if selectedWineCountry == nil {
                    selectedWineCountry = viewModel.selectedWineCountry
                }
                if selectedWineRegion == nil {
                    selectedWineRegion = viewModel.selectedWineRegion
                }
                if selectedWineSugarAmount == nil {
                    selectedWineSugarAmount = viewModel.selectedWineSugar
                }
            }
            .onChange(of: selectedWineSort) { newValue in
                viewModel.selectedWineSort = newValue
            }
            .onChange(of: selectedPlaceOfPurchase) { newValue in
                viewModel.selectedPlace = newValue
            }
            .onChange(of: selectedWineType) { newValue in
                viewModel.selectedType = newValue
            }
            .onChange(of: selectedSorting) { newValue in
                viewModel.selectedSorting = newValue
            }
            .onChange(of: selectedWineCountry) { newValue in
                viewModel.selectedWineCountry = newValue
            }
            .onChange(of: selectedWineRegion) { newValue in
                viewModel.selectedWineRegion = newValue
            }
            .onChange(of: selectedWineSugarAmount) { newValue in
                viewModel.selectedWineSugar = newValue
            }
        }
    }
}
