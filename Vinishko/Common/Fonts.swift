//
//  Fonts.swift
//  Vinishko
//
//  Created by mttm on 28.08.2023.
//

import SwiftUI

struct MainLogo {
    static let logoText = "Vinishko"
}

struct Fonts {
    static let logo = Font.custom("Roboto-Bold", size: 36)
    
    static let regular12 = Font.system(size: 12)
    static let regular14 = Font.system(size: 14)
    
    static let bold12 = Font.system(size: 12).bold()
    static let bold14 = Font.system(size: 14).bold()
    static let bold17 = Font.system(size: 17).bold()
    static let bold18 = Font.system(size: 18).bold()
    static let bold19 = Font.system(size: 19).bold()
    static let bold28 = Font.system(size: 28).bold()
}
