//
//  Pallete.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI

struct Pallete {
    static let mainColor = Color("MainColor")
    static let borderColor = Color("BorderColor")
    
    static let redWineColor = Color("RedWineColor")
    static let whiteWineColor = Color("WhiteWineColor")
    static let otherWineColor = Color("OtherWineColor")
    
    static let textColor = Color("TextColor")
    static let lightGray = Color("LightGray")
    
    static let segmentPickerBg = Color("SegmentPickerBg")
    static let searchBarBg = Color("SearchBar")
    
    static let ratingBg = Color("RatingBg")
    static let bgColor = Color("BgColor")

    static func getWineColor(_ colorNumber: Int16) -> Color {
        switch colorNumber {
        case 0:
            return Pallete.redWineColor
        case 1:
            return Pallete.whiteWineColor
        case 2:
            return Pallete.otherWineColor
        default:
            return .clear
        }
    }
}
