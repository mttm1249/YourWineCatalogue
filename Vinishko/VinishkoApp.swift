//
//  VinishkoApp.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct VinishkoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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
