//
//  TestCountryPicker.swift
//  Vinishko
//
//  Created by mttm on 31.08.2023.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case countryPicker, regionPicker, grapeVarietiesPicker
    
    var id: Int {
        hashValue
    }
}

struct CountryList: Codable {
    let countries: [Country]
}

struct Country: Codable, Equatable {
    let code: String
    let regions: [String]
}

struct PickersModuleView: View {
    @State private var countries: [Country] = []
    @State private var selectedCountryName: String?
    @State private var activeSheet: ActiveSheet?
    @State private var selectedGrapeVarietiesString: String?
    
    @Binding var selectedCountry: Country?
    @Binding var selectedRegion: String?
    @Binding var selectedGrapeVarieties: [String]
    
    init(
          selectedCountry: Binding<Country?>,
          selectedRegion: Binding<String?>,
          selectedGrapeVarieties: Binding<[String]>
      ) {
          self._selectedCountry = selectedCountry
          self._selectedRegion = selectedRegion
          self._selectedGrapeVarieties = selectedGrapeVarieties

          if let countryURL = Bundle.main.url(forResource: "CountryList", withExtension: "json") {
              do {
                  let data = try Data(contentsOf: countryURL)
                  let decoder = JSONDecoder()
                  if let decodedData = try? decoder.decode(CountryList.self, from: data) {
                      self._countries = State(initialValue: decodedData.countries)
                  }
              } catch {
                  print("Error loading CountryList JSON data: \(error)")
              }
          }
      }
    
    var body: some View {
        VStack(spacing: 15) {
            OptionButton(header: "Сорт", text: $selectedGrapeVarietiesString) {
                activeSheet = .grapeVarietiesPicker
            }
            .onChange(of: selectedGrapeVarieties) { newValue in
                selectedGrapeVarietiesString = newValue.map { $0.localize() }.joined(separator: ", ")
            }
            
            OptionButton(header: "Страна", text: $selectedCountryName) {
                activeSheet = .countryPicker
                selectedRegion = nil
            }
            .onChange(of: selectedCountry) { newValue in
                selectedCountryName = newValue.map { Locale.current.localizedString(forRegionCode: $0.code) ?? $0.code }
            }
            
            OptionButton(header: "Регион", text: $selectedRegion) {
                activeSheet = .regionPicker
            }
            .onChange(of: selectedRegion) { newValue in
                selectedRegion = newValue?.localize() ?? ""
            }
            .disabled(selectedCountry == nil)
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .countryPicker:
                CountryPicker(countries: countries, selectedCountry: $selectedCountry)
            case .regionPicker:
                RegionPicker(regions: selectedCountry?.regions ?? [], selectedRegion: $selectedRegion)
            case .grapeVarietiesPicker:
                GrapeVarietiesPicker(grapeVarieties: Grape.varietiesList, selectedGrapeVarieties: $selectedGrapeVarieties)
            }
        }
    }
}
