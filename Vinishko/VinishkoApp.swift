//
//  VinishkoApp.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI

@main
struct VinishkoApp: App {
    let persistenceController = CoreDataManager.shared.persistentContainer
    @StateObject var bottlesCatalogueViewModel = BottlesCatalogueViewModel(context: CoreDataManager.shared.persistentContainer.viewContext)
    
    init() {
        MigrationService.performInitialMigration()
    }

    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
                .environmentObject(bottlesCatalogueViewModel)
        }
    }
}
