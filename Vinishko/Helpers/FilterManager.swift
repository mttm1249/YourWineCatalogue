//
//  FilterManager.swift
//  Vinishko
//
//  Created by Денис on 05.10.2022.
//

import Foundation

class FilterManager {
    
    var colorIdOptionInfo: Int?
    var placeOfPurchaseOptionInfo: String?
    var countryOptionInfo: String?
    
    // Фильтр отображения доступных опций фильтра
    var filterIsActive: Bool?
    var filterColor: String?
    var filterPurchaseInfo: String?
    var filterCountryInfo: String?
    
    static let shared = FilterManager()
    private init() {}
}
