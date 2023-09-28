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

struct WineTypePicker: View {
    private let wineTypes = [
        "Тихое",
        "Игристое",
        "Другое"
    ]
    @Binding var selectedType: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(wineTypes, id: \.self) { type in
                Button(action: {
                    selectedType = type
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(type)
                        .foregroundColor(Pallete.textColor)
                }
            }
        }
    }
}

struct FiltersView: View {
    @EnvironmentObject var viewModel: BottlesCatalogueViewModel
    @State private var selectedWineSort: String? = nil
    @State private var selectedPlaceOfPurchase: String? = nil
    @State private var selectedWineType: String? = nil
    @State private var selectedPicker: FiltersActiveSheet?
    @State private var showingPicker = false
    
    private func getWineType(_ type: String?) -> Int16 {
        guard let type = type else {
            return -1
        }
        
        switch type {
        case "Тихое":
            return 0
        case "Игристое":
            return 1
        case "Другое":
            return 2
        default:
            return -1
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            FilterButton(header: "По сорту", selectedFilter: $selectedWineSort) {
                selectedPicker = .wineSort
                showingPicker = true
            }
            .onChange(of: selectedWineSort) { newValue in
                selectedWineSort = newValue
            }
            
            FilterButton(header: "По месту покупки", selectedFilter: $selectedPlaceOfPurchase) {
                selectedPicker = .placeOfPurchase
                showingPicker = true
            }
            .onChange(of: selectedPlaceOfPurchase) { newValue in
                selectedPlaceOfPurchase = newValue
            }
            
            FilterButton(header: "По типу вина", selectedFilter: $selectedWineType) {
                selectedPicker = .wineType
                showingPicker = true
            }
            .onChange(of: selectedWineType) { newValue in
                selectedWineType = newValue
            }
            
            Spacer()
            
            Button(action: {
                HapticFeedbackService.generateFeedback(style: .success)
                // Сбрасываем значения фильтров
                selectedWineSort = nil
                selectedWineType = nil
                selectedPlaceOfPurchase = nil
                viewModel.selectedWineSort = nil
                viewModel.selectedPlace = nil
                viewModel.selectedType = nil
            }) {
                Text("Сбросить все фильтры")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Фильтры")
        .sheet(item: $selectedPicker) { item in
            switch item {
            case .wineSort:
                let allSorts = viewModel.wineSorts.flatMap { $0.split(separator: ",").map(String.init) }.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                WineSortPicker(wineSorts: Array(Set(allSorts)).sorted(), selectedWineSort: $selectedWineSort)
            case .placeOfPurchase:
                let allPurchasePlaces = viewModel.placesOfPurchase
                PlaceOfPurchasePicker(placesOfPurchase: allPurchasePlaces, selectedPlace: $selectedPlaceOfPurchase)
            case .wineType:
                WineTypePicker(selectedType: $selectedWineType)
            }
        }
        .onAppear {
            if selectedWineSort == nil {
                selectedWineSort = viewModel.selectedWineSort
            }
            if selectedPlaceOfPurchase == nil {
                selectedPlaceOfPurchase = viewModel.selectedPlace
            }
            // TODO:
            //            if selectedWineType == nil {
            //                selectedWineType = viewModel.selectedType
            //            }
        }
        .onChange(of: selectedWineSort) { newValue in
            viewModel.selectedWineSort = newValue
        }
        .onChange(of: selectedPlaceOfPurchase) { newValue in
            viewModel.selectedPlace = newValue
        }
        .onChange(of: selectedWineType) { newValue in
            viewModel.selectedType = getWineType(newValue)
        }
    }
}
