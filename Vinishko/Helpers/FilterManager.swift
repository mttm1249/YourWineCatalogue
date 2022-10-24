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
    
    static let shared = FilterManager()
    private init() {}
}
