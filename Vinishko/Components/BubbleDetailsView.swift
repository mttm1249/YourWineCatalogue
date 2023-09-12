//
//  BubbleDetailsView.swift
//  Vinishko
//
//  Created by mttm on 30.08.2023.
//

import SwiftUI

struct BubbleDetailsView: View {
    
    var wineColor: Int16
    var wineType: Int16
    var wineSugar: Int16
    var wineCountry: String
    
    private struct Constants {
        static let circleDiameter: CGFloat = 20
        static let fontSize: CGFloat = 12
        static let frameHeight: CGFloat = 20
        static let padding: CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 0.5
        static let spacing: CGFloat = 8
    }
    
    private func getWineColor() -> Color {
        switch wineColor {
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
    
    private func getWineSugar() -> String {
        switch wineSugar {
        case 0:
            return "Сух"
        case 1:
            return "П. сух"
        case 2:
            return "П. слад"
        case 3:
            return "Слад"
        default:
            return ""
        }
    }
    
    private func getWineType() -> String {
        switch wineType {
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
    
    var body: some View {
        HStack(spacing: Constants.spacing) {
            Circle()
                .frame(width: Constants.circleDiameter, height: Constants.circleDiameter)
                .foregroundColor(getWineColor())
            Text(getWineSugar())
                .font(.system(size: Constants.fontSize))
                .foregroundColor(Pallete.textColor)
                .frame(height: Constants.frameHeight)
                .padding(.horizontal, Constants.padding)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(.gray, lineWidth: Constants.lineWidth)
                )
            
            Text(getWineType())
                .font(.system(size: Constants.fontSize))
                .foregroundColor(Pallete.textColor)
                .frame(height: Constants.frameHeight)
                .padding(.horizontal, Constants.padding)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(.gray, lineWidth: Constants.lineWidth)
                )
            
            if wineCountry != "" {
                Text(wineCountry)
                    .font(.system(size: Constants.fontSize))
                    .foregroundColor(Pallete.textColor)
                    .frame(height: Constants.frameHeight)
                    .padding(.horizontal, Constants.padding)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .stroke(.gray, lineWidth: Constants.lineWidth)
                    )
            }
        }
    }
}

struct BubbleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleDetailsView(wineColor: 2,
                          wineType: 1,
                          wineSugar: 3,
                          wineCountry: "Испания")
    }
}
