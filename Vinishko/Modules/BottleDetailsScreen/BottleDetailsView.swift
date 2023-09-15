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
    let fakeImage = UIImage(named: "wine")
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) {
                    BottleImageView(image: uiImage,
                                    rating: bottle.doubleRating.smartDescription)
                }
                //                BottleImageView(image: fakeImage!, rating: bottle.doubleRating.smartDescription)
                
                // Bottle name
                Text(bottle.name ?? "")
                    .font(.system(size: 28)).bold()
                    .padding(.horizontal, 16)
                
                // Wine sort
                Text(bottle.wineSort?.localize() ?? "")
                    .font(.system(size: 18)).bold()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                // Wine info
                InfoBubbles(header: "Описание",
                            content: [viewModel.getWineColorName(for: bottle),
                                      viewModel.getWineSugar(for: bottle),
                                      viewModel.getWineType(for: bottle)],
                            firstItemBorderStyle: .thick(viewModel.getWineColor(for: bottle)))
                
                // Country & Region info
                InfoBubbles(header: "Происхождение",
                            content: [LocalizationManager.shared.getWineCountry(for: bottle),
                                      bottle.wineRegion ?? ""])
                
                // Purchase info
                InfoBubbles(header: "Покупка",
                            content: [bottle.placeOfPurchase ?? "",
                                     "\(bottle.price ?? "")₽"])
                
                // Bottle Description
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
    }
}

struct BottleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let previewContext = NSManagedObjectContext.preview
        let bottle = Bottle(context: previewContext)
        bottle.name = "Test Bottle With Loong Naming "
        bottle.wineSort = "Wine sort"
        bottle.bottleDescription = "This is a test description."
        bottle.wineSugar = 1
        
        return BottleDetailsView(viewModel: BottleDetailsViewModel(), bottle: bottle)
    }
}

extension NSManagedObjectContext {
    static var preview: NSManagedObjectContext {
        let container = NSPersistentContainer(name: "Bottle")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        let context = container.viewContext
        
        let newBottle = Bottle(context: context)
        newBottle.name = "Sample Bottle"
    
        
        return context
    }
}

