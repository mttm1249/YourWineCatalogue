//
//  CountryPicker.swift
//  Vinishko
//
//  Created by mttm on 01.09.2023.
//

import SwiftUI

struct CountryPicker: View {
    @Environment(\.presentationMode) var presentationMode
   
    @State var searchText: String = ""
    let countries: [Country]
    @Binding var selectedCountry: Country?
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter {
                (Locale.current.localizedString(forRegionCode: $0.code) ?? "").lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    private func getCountryFlag(_ countryCode: String) -> String {
        String(String.UnicodeScalarView(countryCode.unicodeScalars.compactMap {
            UnicodeScalar(127397 + $0.value)}))
    }
    
    var body: some View {
        VStack {
            SearchBarView(text: $searchText)
                .padding(.top, 20)
            
            if filteredCountries.isEmpty {
                Button("Добавить страну: \(searchText)?") {
                    selectedCountry = Country(code: searchText, regions: [])
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            
            List(filteredCountries, id: \.code) { country in
                Button(action: {
                    selectedCountry = country
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(getCountryFlag(country.code))
                        Text(Locale.current.localizedString(forRegionCode: country.code) ?? "")
                            .foregroundColor(Pallete.textColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct CountryPicker_Previews: PreviewProvider {
    static var previews: some View {
        let countries = [
            Country(code: "RU", regions: ["2"]),
            Country(code: "AM", regions: ["3"])
        ]
        return CountryPicker(countries: countries, selectedCountry: .constant(countries[0]))
    }
}

