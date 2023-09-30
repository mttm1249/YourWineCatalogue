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
                ForEach(wineSorts, id: \.self) { wineSort in
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

struct PlaceOfPurchasePicker: View {
    var placesOfPurchase: [String]
    @Binding var selectedPlace: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if placesOfPurchase.isEmpty {
            Text("Список мест покупки пуст")
                .padding()
                .foregroundColor(.gray)
        } else {
            List {
                ForEach(placesOfPurchase, id: \.self) { place in
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
                ForEach(wineCountries, id: \.self) { country in
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
            Text("Список типов вин пуст")
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

struct FiltersView: View {
    @EnvironmentObject var viewModel: BottlesCatalogueViewModel
    @State private var selectedWineSort: String? = nil
    @State private var selectedWineCountry: String? = nil
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
                
                FilterButton(header: "По типу вина", filterType: .int($selectedWineType)) {
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
              
                // По региону
                                
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
                    selectedPlaceOfPurchase = nil
                    viewModel.selectedWineSort = nil
                    viewModel.selectedPlace = nil
                    viewModel.selectedType = nil
                    viewModel.selectedSorting = 0
                    viewModel.selectedWineCountry = nil
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
        }
    }
}
