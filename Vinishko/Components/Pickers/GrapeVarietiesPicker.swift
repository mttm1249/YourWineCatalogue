//
//  GrapeVarietiesPicker.swift
//  Vinishko
//
//  Created by mttm on 01.09.2023.
//

import SwiftUI

struct GrapeVarietiesPicker: View {
    @Environment(\.presentationMode) var presentationMode
  
    @State var searchText: String = ""
    let grapeVarieties: [String]
        var localizedGrapeVarieties: [String] {
        return grapeVarieties.map { $0.localize() }
    }
    @Binding var selectedGrapeVarieties: [String]
    
    private var filteredVarieties: [String] {
        if searchText.isEmpty {
            return localizedGrapeVarieties
        } else {
            return localizedGrapeVarieties.filter { variety in
                variety.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Button("Закрыть") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
            SearchBarView(text: $searchText)
            HStack(alignment: .top) {
                Text(selectedGrapeVarieties.map { $0.localize() }.joined(separator: ", "))
                    .lineLimit(3)
                Spacer()
                if !selectedGrapeVarieties.isEmpty {
                    Button("Очистить") {
                        selectedGrapeVarieties.removeAll()
                    }
                }
            }
            .padding()
            .background(Pallete.searchBarBg)
            .cornerRadius(10)
            .padding(.horizontal)
            
            if filteredVarieties.isEmpty && !searchText.isEmpty {
                Button(action: {
                    if selectedGrapeVarieties.count < 10 {
                        selectedGrapeVarieties.append(searchText)
                    }
                }) {
                    HStack {
                        Text("Добавить")
                        Text(searchText).underline()
                    }
                }
                .padding()
            }
            
            List(filteredVarieties, id: \.self) { variety in
                let originalVariety = grapeVarieties[localizedGrapeVarieties.firstIndex(of: variety)!]
                Button(action: {
                    if selectedGrapeVarieties.contains(originalVariety) {
                        selectedGrapeVarieties.removeAll { $0 == originalVariety }
                    } else {
                        if selectedGrapeVarieties.count < 10 {
                            selectedGrapeVarieties.append(originalVariety)
                        }
                    }
                }) {
                    HStack {
                        Text(variety)
                            .foregroundColor(Pallete.textColor)
                        Spacer()
                        if selectedGrapeVarieties.contains(originalVariety) {
                            Image(systemName: Images.checkMark)
                        }
                    }
                }
            }
        }
    }
}

struct GrapeVarietiesPicker_Previews: PreviewProvider {
    static var previews: some View {
        GrapeVarietiesPicker(grapeVarieties: ["1", "2", "3"], selectedGrapeVarieties: .constant(["Мерло", "Мальбек", "Гренаш", "Мерло"]))
    }
}
