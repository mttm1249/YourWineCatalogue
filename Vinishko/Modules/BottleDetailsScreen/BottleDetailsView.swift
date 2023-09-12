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
    
    private func getWineColor() -> Color {
        switch bottle.wineColor {
        case 0:
            return Pallete.redWineColor
        case 1:
            return Pallete.whiteWineColor
        case 2:
            return Pallete.otherWineColor
        default:
            return .clear
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                if let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) {
                    BottleImageView(image: uiImage)
                }
//                                BottleImageView(image: fakeImage!)
             
                // Bottle name
                HStack {
                    ZStack {
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(getWineColor())
                        Text(bottle.doubleRating.smartDescription)
                            .foregroundColor(.white)
                            .font(.system(size: 12)).bold()
                    }
                    Text(bottle.name ?? "")
                        .font(.system(size: 28)).bold()
                }
                .padding(.horizontal, 16)
                
                // Wine sort
                Text(bottle.wineSort ?? "")
                    .font(.system(size: 18)).bold()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                
                // Bottle Description
                Text(bottle.bottleDescription ?? "")
                    .font(.system(size: 17))
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
        bottle.name = "Test Bottle"
        bottle.wineSort = "Wine sort"
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

