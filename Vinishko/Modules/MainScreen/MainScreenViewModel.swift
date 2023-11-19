//
//  MainScreenViewModel.swift
//  Vinishko
//
//  Created by mttm on 19.11.2023.
//

import SwiftUI

class MainScreenViewModel: ObservableObject {
    @Published var showSaveBanner = false
    @Published var showMigrationAlert = false
    var offset: CGFloat = 300

    func checkRecordsAndMigrate() {
        MigrationService.performInitialMigration { [weak self] needsMigration in
            DispatchQueue.main.async {
                if needsMigration {
                    // Если нужна миграция, показываем предупреждение
                    self?.showMigrationAlert = true
                }
            }
        }
    }
    
    func userCancelledMigration() {
        MigrationService.performInitialMigration(userCancelled: true)
    }


    func toggleSaveBanner(shouldShow: Bool) {
        if shouldShow {
            showSaveBanner = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.showSaveBanner = false
                }
            }
        }
    }

    func listenForSaveNotification() {
        NotificationCenter.default.addObserver(forName: .didSaveBottleNotification, object: nil, queue: .main) { [weak self] _ in
            self?.toggleSaveBanner(shouldShow: true)
        }
    }
}
