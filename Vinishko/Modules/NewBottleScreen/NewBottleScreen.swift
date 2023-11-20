//
//  NewBottleScreen.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI

struct NewBottleScreen: View {
    
    @StateObject var viewModel: NewBottleViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .topTrailing) {
     
                Button(action: {
                    self.viewModel.showImagePickerSheet = true
                }) {
                    if viewModel.isImageLoading {
                        DownloadProgressView(progress: self.viewModel.downloadProgress)
                            .frame(width: 150, height: 150)
                    } else {
                        Image(uiImage: self.viewModel.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .background(Pallete.segmentPickerBg)
                            .clipShape(Circle())
                    }
                }

                .actionSheet(isPresented: $viewModel.showImagePickerSheet) {
                    ActionSheet(title: Text(Localizable.NewBottleScreenModule.selectSource), buttons: [
                        .default(Text(Localizable.NewBottleScreenModule.camera).foregroundColor(Pallete.textColor), action: {
                            self.viewModel.imagePickerSourceType = .camera
                            self.viewModel.showImagePicker = true
                        }),
                        .default(Text(Localizable.NewBottleScreenModule.gallery).foregroundColor(Pallete.textColor), action: {
                            self.viewModel.imagePickerSourceType = .photoLibrary
                            self.viewModel.showImagePicker = true
                        }),
                        .cancel()
                    ])
                }
                .sheet(isPresented: $viewModel.showImagePicker) {
                    ImagePicker(image: self.$viewModel.image, sourceType: self.viewModel.imagePickerSourceType)
                }
            }
            
            VStack(spacing: 12) {
                RatingView(selectedRating: $viewModel.rating)
                TextFieldStandart(header: Localizable.NewBottleScreenModule.nameTitle, text: $viewModel.bottleName)
                SegmentedPicker(titles: [Localizable.WineColors.red, Localizable.WineColors.white, Localizable.WineColors.other],
                                selectedSegment: $viewModel.colorSelectedSegment)
                SegmentedPicker(titles: [Localizable.WineSugar.dry, Localizable.WineSugar.semiDry, Localizable.WineSugar.semiSweet, Localizable.WineSugar.sweet],
                                selectedSegment: $viewModel.sugarSelectedSegment)
                SegmentedPicker(titles: [Localizable.WineType
                    .still, Localizable.WineType.sparkling, Localizable.WineType.other],
                                selectedSegment: $viewModel.typeSelectedSegment)
                PickersModuleView(
                    selectedCountry: $viewModel.selectedCountry,
                    selectedRegion: $viewModel.selectedRegion,
                    selectedGrapeVarieties: $viewModel.selectedGrapeVarieties
                )
                TextFieldStandart(header: Localizable.NewBottleScreenModule.place, text: $viewModel.placeOfPurchase)
                TextFieldStandart(header: Localizable.NewBottleScreenModule.price, text: $viewModel.price)
                    .keyboardType(.decimalPad)
                TextEditorStandart(header: Localizable.NewBottleScreenModule.comment, text: $viewModel.bottleDescription)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle(Localizable.NewBottleScreenModule.addWine)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.showingQRScanner = true
                }) {
                    Image(systemName: Images.qr)
                }
                .sheet(isPresented: $viewModel.showingQRScanner) {
                    QRCodeScanner(viewModel: viewModel)
                }
                
                Button(action: {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: Images.checkMarkCircle)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(Localizable.NewBottleScreenModule.error),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text(Localizable.NewBottleScreenModule.ok))
            )
        }
    }
}
