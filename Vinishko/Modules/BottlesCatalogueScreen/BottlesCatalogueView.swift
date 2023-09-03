//
//  BottlesCatalogueView.swift
//  Vinishko
//
//  Created by mttm on 28.08.2023.
//

import SwiftUI
import CoreData

struct BottlesCatalogueView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @StateObject var viewModel: BottlesCatalogueViewModel
    @State private var showingAlert = false
    @State private var isFiltersViewActive: Bool = false
    
    var body: some View {
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
                    NavigationLink("", destination: FiltersView(), isActive: $isFiltersViewActive)
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
                            .foregroundColor(Pallete.textColor)
                    }
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.filteredBottles, id: \.self) { bottle in
                            NavigationLink(destination: BottleDetailsView(bottle: bottle)) {
                                BottleCell(name: bottle.name ?? "",
                                           bottleImage: bottle.bottleImage.flatMap { UIImage(data: $0) } ?? UIImage(named: "wine") ?? UIImage(),
                                           bottleDescription: bottle.bottleDescription ?? "",
                                           wineCountry: Locale.current.localizedString(forRegionCode: bottle.wineCountry ?? "") ?? "",
                                           wineSort: bottle.wineSort ?? "",
                                           wineColor: bottle.wineColor,
                                           wineType: bottle.wineType,
                                           wineSugar: bottle.wineSugar,
                                           price: bottle.price ?? "") {
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
        .navigationTitle("Каталог дегустаций")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
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
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}


struct BottlesCatalogueScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BottlesCatalogueView(viewModel: BottlesCatalogueViewModel(context: CoreDataManager.managedContext))
    }
}
