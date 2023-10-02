//
//  BottleDetailsView.swift
//  Vinishko
//
//  Created by mttm on 29.08.2023.
//

import SwiftUI
import CoreData


struct BottleDetailsView: View {
    
    @StateObject var viewModel: BottleDetailsViewModel
    var bottle: Bottle
    @State private var showingSheet = false
    @State var showSaveBanner = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) {
                    BottleImageView(image: uiImage, rating: bottle.doubleRating.smartDescription)
                        .onTapGesture {
                            self.showingSheet = true
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
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle("Сведения о дегустации")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: NewBottleScreen(editableBottle: bottle, showSaveBanner: $showSaveBanner)) {
                    Text("Ред.")
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            if let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) {
                BottlePhotoView(bottle: bottle,
                                tastingDate: viewModel.getCreateDateString(bottle: bottle),
                                image: uiImage)
            }
        }
    }
}

//struct BottleDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let previewContext = NSManagedObjectContext.preview
//        let bottle = Bottle(context: previewContext)
//        bottle.name = "Test Bottle With Loong Naming "
//        bottle.wineSort = "Wine sort"
//        bottle.bottleDescription = "This is a test description."
//        bottle.wineSugar = 1
//
//        return BottleDetailsView(viewModel: BottleDetailsViewModel(), bottle: bottle)
//    }
//}
//
//extension NSManagedObjectContext {
//    static var preview: NSManagedObjectContext {
//        let container = NSPersistentContainer(name: "Bottle")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//
//        let context = container.viewContext
//
//        let newBottle = Bottle(context: context)
//        newBottle.name = "Sample Bottle"
//
//
//        return context
//    }
//}

