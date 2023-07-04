//
//  AppDelegate.swift
//  Vinishko
//
//  Created by Денис on 01.10.2022.
//

import UIKit
import RealmSwift
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Set default settings for QR (first start)
    private func setDefaultSettingsForQR() {
        if !userDefaults.bool(forKey: "qrSettings") {
            userDefaults.set(true, forKey: "qrSettings")
            userDefaults.set(true, forKey: "shareImage")
            userDefaults.set(true, forKey: "shareComment")
            userDefaults.set(true, forKey: "shareRating")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setDefaultSettingsForQR()
        let schemaVersion: UInt64 = 1
        let config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < schemaVersion) {
                }
            })
        
        Realm.Configuration.defaultConfiguration = config
        FirebaseApp.configure()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

