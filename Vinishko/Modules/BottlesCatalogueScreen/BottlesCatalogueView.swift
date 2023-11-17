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
    
    var body: some View {
        VStack {
            VStack {
                SearchBarView(text: $viewModel.searchText)
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.applyFilters()
                    }
                HStack {
                    Button(action: {
                        viewModel.isFiltersViewActive = true
                    }) {
                        Text("Фильтры")
                            .font(.system(size: 14))
                    }
                    .background(
                        NavigationLink(
                            "",
                            destination: FiltersView()
                                .environmentObject(viewModel),
                            isActive: $viewModel.isFiltersViewActive
                        )
                        .opacity(0)
                    )
                    Text("|")
                        .foregroundColor(.gray)
                    SegmentedControl(selectedSegment: $viewModel.selectedSegment, titles: ["Красное", "Белое", "Другие"])
                }
                .onChange(of: viewModel.selectedSegment) { _ in
                    viewModel.applyFilters()
                    if viewModel.selectedSorting != 0 {
                        viewModel.applySorting()
                    }
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
                                NavigationLink(destination: BottleDetailsView(bottle: bottle, viewModel: BottleDetailsViewModel(bottle: bottle))) {
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
                                        rating: bottle.doubleRating,
                                        editAction: {
                                            viewModel.selectedBottle = bottle
                                            viewModel.isEditViewActive = true
                                        },
                                        shareAction: {
                                            viewModel.selectedBottle = bottle
                                            viewModel.uploadImageAndGenerateQRCode(imageData: bottle.bottleImage)
                                            withAnimation {
                                                viewModel.showQRSheet = true
                                            }
                                        },
                                        deleteAction: {
                                            viewModel.selectedBottle = bottle
                                            viewModel.showingAlert = true
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .alert(isPresented: $viewModel.showingAlert) {
                        Alert(title: Text("Вы уверены?"),
                              message: Text("Вы действительно хотите удалить эту бутылку?"),
                              primaryButton: .destructive(Text("Удалить")) {
                            if let bottle = viewModel.selectedBottle {
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
                    Button(action: {
                        viewModel.isSettingsViewActive = true
                    }) {
                        Label("Настройки QR", systemImage: Images.qr)
                    }
                    Button(action: {
                        viewModel.isStatisticsViewActive = true
                    }) {
                        Label("Статистика", systemImage: Images.chart)
                    }
                } label: {
                    Image(systemName: Images.hamburger)
                }
            }
        }
        .background(
            VStack {
                NavigationLink(
                    "",
                    destination: SettingsScreenView(),
                    isActive: $viewModel.isSettingsViewActive
                )
                .opacity(0)
                .frame(width: 0, height: 0)
                
                NavigationLink(
                    "",
                    destination: StatisticsScreen(viewModel: StatisticsScreenViewModel(bottles: viewModel.allBottles)),
                    isActive: $viewModel.isStatisticsViewActive
                )
                .opacity(0)
                .frame(width: 0, height: 0)
                
                NavigationLink(
                    "",
                    destination: NewBottleScreen(viewModel: NewBottleViewModel(editableBottle: viewModel.selectedBottle,
                                                                               context: CoreDataManager.managedContext)),
                    isActive: $viewModel.isEditViewActive
                )
                .opacity(0)
                .frame(width: 0, height: 0)
                
            }
        )
        .overlay(
            BottomSheet(isShowing: $viewModel.showQRSheet) {
                VStack {
                    Text("Сканируйте через Vinishko")
                        .font(.system(size: 18)).bold()
                    Spacer()
                    if viewModel.isUploading {
                        ProgressView()
                            .scaleEffect(1.5)
                    } else if let image = viewModel.qrCodeImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                    Spacer()
                }
            }
                .edgesIgnoringSafeArea(.all)
        )
    }
}
