//
//  BottleDetailsView.swift
//  Vinishko
//
//  Created by mttm on 29.08.2023.
//

import SwiftUI
import CoreData

struct BottleDetailsView: View {
    
    var bottle: Bottle
    @ObservedObject var viewModel: BottleDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) {
                    // Если изображение существует, отображаем его
                    BottleImageView(image: uiImage, rating: bottle.doubleRating.smartDescription)
                        .onTapGesture {
                            self.viewModel.showingSheet = true
                        }
                } else {
                    // Если изображение отсутствует, отображаем запасное изображение
                    BottleImageView(image: UIImage(named: "wine")!, rating: bottle.doubleRating.smartDescription)
                        .onTapGesture {
                            self.viewModel.showingSheet = true
                        }
                }

                Text(bottle.name ?? "")
                    .font(.system(size: 28)).bold()
                    .padding(.horizontal, 16)
                
                Text(bottle.wineSort?.localize() ?? "")
                    .font(.system(size: 18)).bold()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                InfoBubbles(header: "Описание",
                            content: [viewModel.getWineColorName(for: bottle),
                                      viewModel.getWineSugar(for: bottle),
                                      viewModel.getWineType(for: bottle)],
                            firstItemBorderStyle: .thick(viewModel.getWineColor(for: bottle)))
                
                InfoBubbles(header: "Происхождение",
                            content: [LocalizationManager.shared.getWineCountry(from: bottle.wineCountry),
                                      bottle.wineRegion ?? ""])
                
                InfoBubbles(header: "Покупка",
                            content: [bottle.placeOfPurchase ?? "",
                                      "\(bottle.price ?? "")₽"])
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Комментарий")
                        .font(.system(size: 14)).bold()
                        .foregroundColor(.gray)
                    
                    Text(bottle.bottleDescription ?? "")
                        .font(.system(size: 14))
                    Divider()
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle("Сведения о дегустации")
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
            //TODO: ситуация если изображение не было добавлено
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
                    Text("Сканируйте через Vinishko")
                        .font(.system(size: 18)).bold()
                    Spacer()
                    if viewModel.isUploading {
                        ProgressView()
                            .scaleEffect(1.2)
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
