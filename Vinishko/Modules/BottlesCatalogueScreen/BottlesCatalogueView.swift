//
//  BottlesCatalogueView.swift
//  Vinishko
//
//  Created by mttm on 28.08.2023.
//

import SwiftUI
import CoreData

struct BottlesCatalogueView: View {
    @EnvironmentObject var viewModel: BottlesCatalogueViewModel
    @State private var showingAlert = false
    @State private var isFiltersViewActive: Bool = false
    
    var body: some View {
        VStack {
                VStack {
                    SearchBarView(text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { _ in
                            viewModel.applyFilters()
                        }
                    HStack {
                        Button(action: {
                            self.isFiltersViewActive = true
                        }) {
                            Text("Фильтры")
                                .font(.system(size: 14))
                        }
                        .background(
                            NavigationLink(
                                 "",
                                 destination: FiltersView()
                                     .environmentObject(viewModel),
                                 isActive: $isFiltersViewActive
                             )
                                .opacity(0)
                        )
                        Text("|")
                            .foregroundColor(.gray)
                        SegmentedControl(selectedSegment: $viewModel.selectedSegment, titles: ["Красное", "Белое", "Другие"])
                    }
                    .onChange(of: viewModel.selectedSegment) { _ in
                        viewModel.applyFilters()
                    }
                    .padding()
                    Spacer()
                    if viewModel.filteredBottles.isEmpty {
                        VStack {
                            Spacer()
                            HStack {
                                Text("Записи отсутствуют")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                ForEach(viewModel.filteredBottles, id: \.self) { bottle in
                                    NavigationLink(destination: BottleDetailsView(viewModel: BottleDetailsViewModel(), bottle: bottle)) {
                                        BottleCell(
                                            name: bottle.name ?? "",
                                            bottleImage: viewModel.getBottleImage(for: bottle),
                                            bottleDescription: bottle.bottleDescription ?? "",
                                            wineCountry: LocalizationManager.shared.getWineCountry(from: bottle.wineCountry),
                                            wineSort: bottle.wineSort ?? "",
                                            wineColor: bottle.wineColor,
                                            wineType: bottle.wineType,
                                            wineSugar: bottle.wineSugar,
                                            price: bottle.price ?? "",
                                            rating: bottle.doubleRating
                                        ) {
                                            self.viewModel.bottleToDelete = bottle
                                            self.showingAlert = true
                                        }
                                    }
                                }
                            }
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Вы уверены?"),
                                  message: Text("Вы действительно хотите удалить эту бутылку?"),
                                  primaryButton: .destructive(Text("Удалить")) {
                            if let bottle = viewModel.bottleToDelete {
                                viewModel.deleteBottle(bottle)
                            }
                            HapticFeedbackService.generateFeedback(style: .success)
                        },
                                  secondaryButton: .cancel(Text("Отмена"))
                            )
                        }
                    }
                }
        }
        .navigationTitle("Каталог дегустаций")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: {
                        CoreDataManager.shared.deleteAllData()
                    }) {
                        HStack {
                            Text("Удалить все записи CD")
                            Image(systemName: "gear")
                        }
                    }
                    Button(action: {}) {
                        HStack {
                            Text("Настройки QR")
                            Image(systemName: "qrcode")
                        }
                    }
                    Button(action: {}) {
                        HStack {
                            Text("Статистика")
                            Image(systemName: "chart.pie.fill")
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
            }
        }
    }
}

//struct BottlesCatalogueScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottlesCatalogueView(viewModel: BottlesCatalogueViewModel(context: CoreDataManager.managedContext))
//    }
//}
