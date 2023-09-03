//
//  VinishkoApp.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI

@main
struct VinishkoApp: App {
    
    init() {
        MigrationService.performInitialMigration()
    }

    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .environment(\.managedObjectContext, CoreDataManager.managedContext)
        }
    }
}
