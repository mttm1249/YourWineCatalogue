//
//  FiltersView.swift
//  Vinishko
//
//  Created by mttm on 29.08.2023.
//

import SwiftUI

enum FiltersActiveSheet: Identifiable {
    case wineSort, placeOfPurchase
    
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

struct FiltersView: View {
    @EnvironmentObject var viewModel: BottlesCatalogueViewModel
    @State private var selectedWineSort: String? = nil
    @State private var selectedPlaceOfPurchase: String? = nil
    @State private var selectedPicker: FiltersActiveSheet?
    @State private var showingPicker = false
    
    var body: some View {
        VStack {
            OptionButton(header: "По сорту", text: $selectedWineSort) {
                selectedPicker = .wineSort
                showingPicker = true
            }
            .onChange(of: selectedWineSort) { newValue in
                selectedWineSort = newValue
            }
            
            OptionButton(header: "По месту покупки", text: $selectedPlaceOfPurchase) {
                selectedPicker = .placeOfPurchase
                showingPicker = true
            }
            .onChange(of: selectedPlaceOfPurchase) { newValue in
                selectedPlaceOfPurchase = newValue
            }
            
            Spacer()
            
            Button(action: {
                // Сбрасываем значения фильтров
                selectedWineSort = nil
                selectedPlaceOfPurchase = nil
                viewModel.selectedWineSort = nil
                viewModel.selectedPlace = nil
            }) {
                Text("Сбросить фильтры")
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
            }
        }
        .onAppear {
            if selectedWineSort == nil {
                selectedWineSort = viewModel.selectedWineSort
            }
            if selectedPlaceOfPurchase == nil {
                selectedPlaceOfPurchase = viewModel.selectedPlace
            }
        }
        .onChange(of: selectedWineSort) { newValue in
            viewModel.selectedWineSort = newValue
        }
        .onChange(of: selectedPlaceOfPurchase) { newValue in
            viewModel.selectedPlace = newValue
        }
    }
}
