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
    
    func getWineCountry(from country: String?) -> String {
        if let countryCode = country {
            if let localizedCountry = Locale.current.localizedString(forRegionCode: countryCode) {
                return localizedCountry
            } else {
                return countryCode
            }
        }
        return ""
    }
    
    func getWineType(_ name: Int16?) -> String {
        guard let name = name else {
            return ""
        }
        
        switch name {
        case 0:
            return "Тихое"
        case 1:
            return "Игристое"
        case 2:
            return "Другое"
        default:
            return ""
        }
    }
}
