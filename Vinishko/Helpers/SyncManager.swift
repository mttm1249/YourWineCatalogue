//
//  SyncManager.swift
//  Vinishko
//
//  Created by mttm on 13.04.2023.
//

import Network
import UIKit

class SyncManager {
    static let shared = SyncManager()
    
    var bottlesToUpload: [String] {
        get {
            return UserDefaults.standard.array(forKey: "bottlesToUpload") as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bottlesToUpload")
        }
    }

    private let monitor = NWPathMonitor()

     init() {
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }

    func uploadBottlesIfConnected() {
        let isConnected = monitor.currentPath.status == .satisfied
        if isConnected {
            for localID in bottlesToUpload {
                if let bottle = StorageManager.getStoredBottle(byLocalID: localID) {
                    CloudManager.saveDataToCloud(bottle: bottle, bottleImage: UIImage(data: bottle.bottleImage!)!) { recordId in
                        DispatchQueue.main.async {
                            try! realm.write {
                                bottle.recordID = recordId
                            }
                            self.bottlesToUpload.removeAll { $0 == localID }
                        }
                    }
                } else {
                    // Bottle not found in local storage, remove it from the list
                    bottlesToUpload.removeAll { $0 == localID }
                }
            }
        }
    }
}


