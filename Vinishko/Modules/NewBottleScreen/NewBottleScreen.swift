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
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .camera
        
    @State private var showImagePicker: Bool = false
    @State private var showActionSheet: Bool = false
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .topTrailing) {
                Button {
                    self.showActionSheet = true
                } label: {
                    Image(uiImage: self.viewModel.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .background(Pallete.segmentPickerBg)
                        .clipShape(Circle())
                }
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Выберите источник"), buttons: [
                        .default(Text("Камера").foregroundColor(Pallete.textColor), action: {
                            self.imagePickerSourceType = .camera
                            self.showImagePicker = true
                        }),
                        .default(Text("Галерея").foregroundColor(Pallete.textColor), action: {
                            self.imagePickerSourceType = .photoLibrary
                            self.showImagePicker = true
                        }),
                        .cancel()
                    ])
                }
                .sheet(isPresented: $showImagePicker, content: {
                    ImagePicker(image: self.$viewModel.image, sourceType: self.imagePickerSourceType)
                })
            }
            
            VStack(spacing: 12) {
                RatingView(selectedRating: $viewModel.rating)
                TextFieldStandart(header: "Название", text: $viewModel.bottleName)
                SegmentedPicker(titles: ["Красное", "Белое", "Другое"],
                                selectedSegment: $viewModel.colorSelectedSegment)
                SegmentedPicker(titles: ["Сух", "П. сух", "П. слад", "Слад"],
                                selectedSegment: $viewModel.sugarSelectedSegment)
                SegmentedPicker(titles: ["Тихое", "Игристое", "Другое"],
                                selectedSegment: $viewModel.typeSelectedSegment)
                PickersModuleView(
                    selectedCountry: $viewModel.selectedCountry,
                    selectedRegion: $viewModel.selectedRegion,
                    selectedGrapeVarieties: $viewModel.selectedGrapeVarieties
                )
                TextFieldStandart(header: "Место покупки", text: $viewModel.placeOfPurchase)
                TextFieldStandart(header: "Цена", text: $viewModel.price)
                    .keyboardType(.decimalPad)
                TextEditorStandart(header: "Комментарий", text: $viewModel.bottleDescription)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Добавить винишко")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showingQRScanner = true
                } label: {
                    Image(systemName: Images.qr)
                }
                .sheet(isPresented: $viewModel.showingQRScanner) {
                    QRCodeScannerView()
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

    }
}
