//
//  LocalizationManager.swift
//  Vinishko
//
//  Created by mttm on 15.09.2023.
//

import Foundation

class LocalizationManager {
    
    static let shared = LocalizationManager()
    
    private init() {}
    
    func getWineCountry(for bottle: Bottle) -> String {
        if let country = bottle.wineCountry {
            if let localizedCountry = Locale.current.localizedString(forRegionCode: country) {
                return localizedCountry
            } else {
                return country
            }
        }
        return ""
    }
}
