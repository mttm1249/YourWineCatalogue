//
//  BottleDetailsView.swift
//  Vinishko
//
//  Created by mttm on 29.08.2023.
//

import SwiftUI
import CoreData

struct BottleDetailsView: View {
    
    @ObservedObject var viewModel: BottleDetailsViewModel
    private let lm = LocalizationManager.shared
    var bottle: Bottle
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) {
                    // Если изображение существует, отображаем его
                    BottleImageView(image: uiImage, rating: bottle.doubleRating.smartDescription, onImageTap: {
                        self.viewModel.showingSheet = true
                    })
                } else {
                    // Если изображение отсутствует, отображаем запасное изображение
                    BottleImageView(image: UIImage(named: "wine")!, rating: bottle.doubleRating.smartDescription, onImageTap: {
                        self.viewModel.showingSheet = true
                    })
                }
                
                Text(bottle.name ?? "")
                    .font(Fonts.bold28)
                    .padding(.horizontal, 16)
                
                Text(bottle.wineSort?.localize() ?? "")
                    .font(Fonts.bold18)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                InfoBubbles(header: Localizable.BottleDetailsModule.description,
                            content: [lm.getWineColorName(for: bottle),
                                      lm.getWineSugar(bottle.wineSugar),
                                      lm.getWineType(bottle.wineType)],
                            firstItemBorderStyle: .thick(Pallete.getWineColor(bottle.wineColor)))
                
                InfoBubbles(header: Localizable.BottleDetailsModule.origin,
                            content: [LocalizationManager.shared.getWineCountry(from: bottle.wineCountry),
                                      bottle.wineRegion ?? ""])
                
                InfoBubbles(header: Localizable.BottleDetailsModule.purchase,
                            content: [bottle.placeOfPurchase ?? "",
                                      "\(bottle.price ?? "")\(Localizable.UIComponents.currency)"])
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(Localizable.BottleDetailsModule.comment)
                        .font(Fonts.bold14)
                        .foregroundColor(.gray)
                    
                    Text(bottle.bottleDescription ?? "")
                        .font(Fonts.regular14)
                    Divider()
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle(Localizable.BottleDetailsModule.details).navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(destination: NewBottleScreen(viewModel: NewBottleViewModel(editableBottle: bottle, context: CoreDataManager.managedContext, onBottleSaved: { updatedBottle in
                    self.viewModel.updateBottle(updatedBottle)
                }))) {
                    Image(systemName: Images.pencil)
                }
                
                Button {
                    viewModel.uploadImageAndGenerateQRCode(imageData: bottle.bottleImage)
                    withAnimation {
                        self.viewModel.showQRSheet.toggle()
                    }
                } label: {
                    Image(systemName: Images.qr)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingSheet) {
            if let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) {
                BottlePhotoView(bottle: bottle,
                                tastingDate: viewModel.getCreateDateString(bottle: bottle),
                                image: uiImage)
            }
        }
        // Bottom Sheet для QR кода
        .overlay(
            BottomSheet(isShowing: $viewModel.showQRSheet) {
                VStack {
                    Text(Localizable.BottleDetailsModule.scan)
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
                        Text(bottle.name ?? "")
                            .font(Fonts.regular14)
                    }
                    Spacer()
                }
            }
                .edgesIgnoringSafeArea(.all)
        )
    }
}
