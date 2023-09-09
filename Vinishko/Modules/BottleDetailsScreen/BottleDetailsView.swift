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
    
    let fakeImage = UIImage(named: "wine")

    var body: some View {
        ScrollView {
            VStack(spacing: -5) {
                if let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) {
                    BottleImageView(image: uiImage)
                }
//                BottleImageView(image: fakeImage!)

                BottomDetailsView(descriptionText: bottle.bottleDescription ?? "",
                                  grapeVarieties: bottle.wineSort ?? "",
                                  placeOfPurchaseInfo: bottle.placeOfPurchase ?? "",
                                  priceInfo: bottle.price ?? "",
                                  rating: bottle.doubleRating.stringWithoutTrailingZeroes)
            }
            .navigationTitle(bottle.name ?? "")
        }
    }
}


struct BottleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let previewContext = NSManagedObjectContext.preview
        let bottle = Bottle(context: previewContext)
        bottle.name = "Test Bottle"
        bottle.bottleDescription = "This is a test description."

        return BottleDetailsView(bottle: bottle)
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

