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
                        Text(Localizable.BottlesCatalogueModule.filters)
                            .font(Fonts.regular14)
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
                    SegmentedControl(selectedSegment: $viewModel.selectedSegment, titles: [Localizable.WineColors.red, Localizable.WineColors.white, Localizable.WineColors.other])
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
                            Text(Localizable.BottlesCatalogueModule.empty)
                                .font(Fonts.bold14)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(viewModel.filteredBottles, id: \.self) { bottle in
                                NavigationLink(destination: BottleDetailsView(viewModel: BottleDetailsViewModel(bottle: bottle), bottle: bottle)) {
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
                        Alert(title: Text(Localizable.BottlesCatalogueModule.deleting),
                              message: Text(Localizable.BottlesCatalogueModule.message),
                              primaryButton: .destructive(Text(Localizable.BottlesCatalogueModule.delete)) {
                            if let bottle = viewModel.selectedBottle {
                                viewModel.deleteBottle(bottle)
                            }
                            HapticFeedbackService.generateFeedback(style: .success)
                        },
                              secondaryButton: .cancel(Text(Localizable.BottlesCatalogueModule.cancel))
                        )
                    }
                }
            }
        }
        .navigationTitle(Localizable.BottlesCatalogueModule.catalogue).navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        viewModel.isStatisticsViewActive = true
                    }) {
                        Label(Localizable.BottlesCatalogueModule.statistics, systemImage: Images.chart)
                    }
                    Button(action: {
                        viewModel.isSettingsViewActive = true
                    }) {
                        Label(Localizable.BottlesCatalogueModule.settingsQR, systemImage: Images.qr)
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
                    Text(Localizable.BottlesCatalogueModule.scan)
                        .font(Fonts.bold18)
                    Spacer()
                    if viewModel.isUploading {
                        ProgressView()
                            .scaleEffect(1.2)
                    } else if let image = viewModel.qrCodeImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Text(viewModel.selectedBottle?.name ?? "")
                            .font(Fonts.regular14)
                    }
                    Spacer()
                }
            }
                .edgesIgnoringSafeArea(.all)
        )
    }
}
