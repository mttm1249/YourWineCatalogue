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
                        ProgressView()
                            .onAppear {
                                print("isImageLoading: true")
                            }
                    } else {
                        Image(uiImage: self.viewModel.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .background(Pallete.segmentPickerBg)
                            .clipShape(Circle())
                            .onAppear {
                                print("isImageLoading: false")
                            }
                    }
                }


                .actionSheet(isPresented: $viewModel.showImagePickerSheet) {
                    ActionSheet(title: Text("Выберите источник"), buttons: [
                        .default(Text("Камера").foregroundColor(Pallete.textColor), action: {
                            self.viewModel.imagePickerSourceType = .camera
                            self.viewModel.showImagePicker = true
                        }),
                        .default(Text("Галерея").foregroundColor(Pallete.textColor), action: {
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
                title: Text("Ошибка"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
