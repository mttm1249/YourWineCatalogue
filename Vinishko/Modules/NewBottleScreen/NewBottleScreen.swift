//
//  NewBottleScreen.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI

struct NewBottleScreen: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var viewModel: NewBottleScreenViewModel
    
    @State private var showImagePicker: Bool = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var image: UIImage = UIImage(named: "addImage") ?? UIImage()
    @State private var showActionSheet: Bool = false

    
    @Binding var showSaveBanner: Bool
    @State private var showSheet = false
    @State private var bottleName: String = ""
    @State private var placeOfPurchase: String = ""
    @State private var price: String = ""
    @State private var rating: Double = 0
    @State private var bottleDescription: String = ""
    @State private var colorSelectedSegment = 0
    @State private var sugarSelectedSegment = 0
    @State private var typeSelectedSegment = 0
    @State private var selectedCountry: Country?
    @State private var selectedRegion: String?
    @State private var selectedGrapeVarieties: [String] = []
    
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .topTrailing) {
                Button {
                    self.showActionSheet = true
                } label: {
                    Image(uiImage: self.image)
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
                                      ImagePicker(image: self.$image, sourceType: self.imagePickerSourceType)
                                  })
            }
            
            VStack(spacing: 12) {
                RatingView(selectedRating: $rating)
                TextFieldStandart(header: "Название", text: $bottleName)
                SegmentedPicker(titles: ["Красное", "Белое", "Другое"],
                                selectedSegment: $colorSelectedSegment)
                SegmentedPicker(titles: ["Сух", "П. сух", "П. слад", "Слад"],
                                selectedSegment: $sugarSelectedSegment)
                SegmentedPicker(titles: ["Тихое", "Игристое", "Другое"],
                                selectedSegment: $typeSelectedSegment)
                PickersModuleView(
                    selectedCountry: $selectedCountry,
                    selectedRegion: $selectedRegion,
                    selectedGrapeVarieties: $selectedGrapeVarieties
                )
                TextFieldStandart(header: "Место покупки", text: $placeOfPurchase)
                TextFieldStandart(header: "Цена", text: $price)
                    .keyboardType(.decimalPad)
                TextEditorStandart(header: "Комментарий", text: $bottleDescription)
            }
            .hideKeyboard()
            .padding(.bottom, 20)
        }
        .navigationTitle("Добавить винишко")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    CoreDataManager.saveBottleRecord(
                        name: bottleName,
                        wineSort: selectedGrapeVarieties,
                        wineCountry: selectedCountry?.code,
                        wineRegion: selectedRegion,
                        placeOfPurchase: placeOfPurchase,
                        price: price,
                        rating: 0,
                        bottleDescription: bottleDescription,
                        wineColor: colorSelectedSegment,
                        wineSugar: sugarSelectedSegment,
                        wineType: typeSelectedSegment,
//                        image: viewModel.cropToSquare(image: image),
                        image: image,
                        createDate: Date(),
                        isOldRecord: false,
                        doubleRating: rating
                    )
                    // Показываем баннер сохранения
                    showSaveBanner = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showSaveBanner = false
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                    HapticFeedbackService.generateFeedback(style: .success)
                }) {
                    Image(systemName: "checkmark.circle")
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

struct NewBottleScreen_Previews: PreviewProvider {
    static var previews: some View {
        NewBottleScreen(viewModel: NewBottleScreenViewModel(), showSaveBanner: .constant(false))
    }
}
