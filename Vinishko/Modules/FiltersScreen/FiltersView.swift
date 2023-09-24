//
//  FiltersView.swift
//  Vinishko
//
//  Created by mttm on 29.08.2023.
//

import SwiftUI

struct WineSortPicker: View {
    var wineSorts: [String]
    @Binding var selectedWineSort: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(wineSorts, id: \.self) { wineSort in
                Button(action: {
                    selectedWineSort = wineSort
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(wineSort)
                }
            }
        }
    }
}

struct FiltersView: View {
    @EnvironmentObject var viewModel: BottlesCatalogueViewModel
    @State private var selectedWineSort: String? = nil
    @State private var showingWineSortPicker = false
    
    var body: some View {
        VStack {
            Button(action: {
                showingWineSortPicker = true
            }) {
                HStack {
                    Text("Сорт")
                    Spacer()
                    Text(selectedWineSort ?? "Не выбрано")
                        .foregroundColor(.gray)
                }
                .padding()
            }
            Button(action: {
                // Сбрасываем значения фильтров
                selectedWineSort = nil
                viewModel.selectedWineSort = nil
                viewModel.selectedSegment = -1
                // ... сброс других фильтров по аналогии
            }) {
                Text("Сбросить фильтры")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Фильтры")
        .sheet(isPresented: $showingWineSortPicker) {
            let allSorts = viewModel.wineSorts.flatMap { $0.split(separator: ",").map(String.init) }.map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
            WineSortPicker(wineSorts: Array(Set(allSorts)).sorted(), selectedWineSort: $selectedWineSort)
        }
        .onChange(of: selectedWineSort) { newValue in
            viewModel.selectedWineSort = newValue
        }
        .onAppear {
            if selectedWineSort == nil {
                selectedWineSort = viewModel.selectedWineSort
            }
        }
    }
}





//struct FiltersView_Previews: PreviewProvider {
//    static var previews: some View {
//        FiltersView(viewModel: BottlesCatalogueViewModel(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)))
//    }
//}

