//
//  BottleDetailsViewModel.swift
//  Vinishko
//
//  Created by mttm on 15.09.2023.
//

import SwiftUI

class BottleDetailsViewModel: ObservableObject {
    
    func getWineColor(for bottle: Bottle) -> Color {
        switch bottle.wineColor {
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
    
    func getWineColorName(for bottle: Bottle) -> String {
        switch bottle.wineColor {
        case 0:
            return "Красное"
        case 1:
            return "Белое"
        case 2:
            return "Другое"
        default:
            return ""
        }
    }
    
    func getWineSugar(for bottle: Bottle) -> String {
        switch bottle.wineSugar {
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
    
    func getWineType(for bottle: Bottle) -> String {
        switch bottle.wineType {
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
