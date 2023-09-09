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

    var body: some View {
        VStack {
            Text(bottle.bottleDescription ?? "")
        }
        .navigationTitle(bottle.name ?? "")
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

