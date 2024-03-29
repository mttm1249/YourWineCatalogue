//
//  RegionPicker.swift
//  Vinishko
//
//  Created by mttm on 01.09.2023.
//

import SwiftUI

struct RegionPicker: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var searchText: String = ""
    let regions: [String]
    @Binding var selectedRegion: String?
    
    var filteredRegions: [String] {
        if searchText.isEmpty {
            return regions
        } else {
            return regions.filter { region in
                region.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack {
            CloseButton(action: {
                presentationMode.wrappedValue.dismiss()
            })
            SearchBarView(text: $searchText)
                .padding(.top, 20)
            
            if filteredRegions.isEmpty {
                Button(action: {
                    selectedRegion = searchText
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(Localizable.UIComponents.addButton)
                            .font(Fonts.bold18)
                        Text(searchText).underline()
                            .font(Fonts.bold18)
                    }
                }
                .padding()
            }
            
            List(filteredRegions, id: \.self) { region in
                Button(action: {
                    selectedRegion = region
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(region.localize())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Pallete.textColor)
                }
            }
        }
    }
}

struct RegionPicker_Previews: PreviewProvider {
    static var previews: some View {
        RegionPicker(regions: ["Doru", "Rioja"], selectedRegion: .constant("4"))
    }
}
