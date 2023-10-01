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
    
    func getWineSugar(_ amount: Int16?) -> String {
        guard let amount = amount else {
            return ""
        }
        
        switch amount {
        case 0:
            return "Сухое"
        case 1:
            return "Полусухое"
        case 2:
            return "Полусладкое"
        case 3:
            return "Сладкое"
        default:
            return ""
        }
    }
}
