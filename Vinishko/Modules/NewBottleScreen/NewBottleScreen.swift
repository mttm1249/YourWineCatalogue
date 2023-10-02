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
    
    var editableBottle: Bottle?
    
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
        .onAppear {
            if editableBottle != nil {
                rating = editableBottle?.doubleRating ?? 0
                bottleName = editableBottle?.name ?? ""
                colorSelectedSegment = Int(editableBottle?.wineColor ?? 0)
                sugarSelectedSegment = Int(editableBottle?.wineSugar ?? 0)
                typeSelectedSegment =  Int(editableBottle?.wineType ?? 0)
                selectedGrapeVarieties.append(editableBottle?.wineSort ?? "")
                //TODO: Добавить страну
                //                selectedCountry =
                selectedRegion = editableBottle?.wineCountry
                placeOfPurchase = editableBottle?.placeOfPurchase ?? ""
                price = editableBottle?.price ?? ""
                bottleDescription = editableBottle?.bottleDescription ?? ""
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if editableBottle != nil {
                        // Редактирование существующей записи
                        editableBottle?.name = bottleName
                        editableBottle?.wineSort = selectedGrapeVarieties.joined(separator: ", ")
                        editableBottle?.wineCountry = checkCountryCode(selectedCountry)
                        editableBottle?.wineRegion = checkRegion(selectedRegion)
                        editableBottle?.placeOfPurchase = placeOfPurchase
                        editableBottle?.price = price
                        editableBottle?.bottleDescription = bottleDescription
                        editableBottle?.wineColor = Int16(colorSelectedSegment)
                        editableBottle?.wineSugar = Int16(sugarSelectedSegment)
                        editableBottle?.wineType = Int16(typeSelectedSegment)
                        //TODO: Добавить изображение в виде Data
                        //editableBottle?.bottleImage = image
                        editableBottle?.doubleRating = rating
                        
                        CoreDataManager.shared.saveContext()
                        
                        presentationMode.wrappedValue.dismiss()
                        HapticFeedbackService.generateFeedback(style: .medium)
                    } else {
                        CoreDataManager.saveBottleRecord(
                            name: bottleName,
                            wineSort: selectedGrapeVarieties,
                            wineCountry: checkCountryCode(selectedCountry),
                            wineRegion: checkRegion(selectedRegion),
                            placeOfPurchase: placeOfPurchase,
                            price: price,
                            rating: 0,
                            bottleDescription: bottleDescription,
                            wineColor: colorSelectedSegment,
                            wineSugar: sugarSelectedSegment,
                            wineType: typeSelectedSegment,
                            image: image,
                            createDate: Date(),
                            isOldRecord: false,
                            doubleRating: rating
                        )
                        showSaveBanner = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showSaveBanner = false
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                        HapticFeedbackService.generateFeedback(style: .success)
                    }
                }) {
                    Image(systemName: "checkmark.circle")
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

extension NewBottleScreen {
    func checkCountryCode(_ selectedCountry: Country?) -> String {
        if let countryCode = selectedCountry?.code {
            return countryCode
        } else {
            return ""
        }
    }
    
    func checkRegion(_ selectedRegion: String?) -> String {
        if let region = selectedRegion {
            return region
        } else {
            return ""
        }
    }
}

//struct NewBottleScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        NewBottleScreen(showSaveBanner: .constant(false))
//    }
//}
