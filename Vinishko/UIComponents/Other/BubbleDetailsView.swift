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
    
    private let lm = LocalizationManager.shared
    
    private struct Constants {
        static let circleDiameter: CGFloat = 20
        static let frameHeight: CGFloat = 20
        static let padding: CGFloat = 5
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1
        static let spacing: CGFloat = 8
    }
                
    var body: some View {
        HStack(spacing: Constants.spacing) {
            Circle()
                .frame(width: Constants.circleDiameter, height: Constants.circleDiameter)
                .foregroundColor(Pallete.getWineColor(wineColor))
            Text(lm.getWineSugar(wineSugar))
                .font(Fonts.regular12)
                .foregroundColor(Pallete.textColor)
                .frame(height: Constants.frameHeight)
                .padding(.horizontal, Constants.padding)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(.gray, lineWidth: Constants.lineWidth)
                )
            
            Text(lm.getWineType(wineType))
                .font(Fonts.regular12)
                .foregroundColor(Pallete.textColor)
                .frame(height: Constants.frameHeight)
                .padding(.horizontal, Constants.padding)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(.gray, lineWidth: Constants.lineWidth)
                )
            
            if wineCountry != "" {
                Text(wineCountry)
                    .font(Fonts.regular12)
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

#Preview {
    BubbleDetailsView(wineColor: 2,
                      wineType: 1,
                      wineSugar: 3,
                      wineCountry: "Испания")
}
