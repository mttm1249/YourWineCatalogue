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
            return Localizable.WineType.still
        case 1:
            return Localizable.WineType.sparkling
        case 2:
            return Localizable.WineType.other
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
            return Localizable.WineSugar.dry
        case 1:
            return Localizable.WineSugar.semiDry
        case 2:
            return Localizable.WineSugar.semiSweet
        case 3:
            return Localizable.WineSugar.sweet
        default:
            return ""
        }
    }
}
