//
//  StorageManager.swift
//  Vinishko
//
//  Created by Денис on 01.10.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ bottle: Bottle) {
        try! realm.write {
            realm.add(bottle)
        }
    }
    
    static func deleteObject(_ bottle: Bottle) {
        try! realm.write {
            realm.delete(bottle)
        }
    }
    
}
