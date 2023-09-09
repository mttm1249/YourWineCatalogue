//
//  BottleCell.swift
//  Vinishko
//
//  Created by mttm on 28.08.2023.
//

import SwiftUI

struct BottleCell: View {
    var name: String
    var bottleImage: UIImage
    var bottleDescription: String
    var wineCountry: String
    var wineSort: String
    var wineColor: Int64
    var wineType: Int64
    var wineSugar: Int64
    var price: String
    var rating: Double
    var action: () -> Void
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 15) {
                VStack {
                    CircleImageView(image: bottleImage)
                        .frame(width: 80, height: 80)
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.orange)
                        Text(rating.stringWithoutTrailingZeroes)
                            .foregroundColor(Pallete.textColor)
                            .font(.system(size: 14)).bold()
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 8) {
                        Text(name)
                            .font(.system(size: 19)).bold()
                            .foregroundColor(Pallete.textColor)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Button(action: {
                            action()
                        }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Pallete.textColor)
                                .frame(width: 20, height: 20)
                        }
                    }
                    Text(wineSort.localize())
                        .font(.system(size: 17)).bold()
                        .foregroundColor(Pallete.textColor)
                        .multilineTextAlignment(.leading)
                    Text(bottleDescription)
                        .font(.system(size: 14))
                        .foregroundColor(Pallete.textColor)
                        .multilineTextAlignment(.leading)
                    HStack {
                        BubbleDetailsView(wineColor: wineColor,
                                          wineType: wineType,
                                          wineSugar: wineSugar,
                                          wineCountry: wineCountry)
                        Spacer()
                    }
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 16)
            Divider()
                .padding(.leading, 111)
        }
    }
}

struct BottleCell_Previews: PreviewProvider {
    static var previews: some View {
        BottleCell(name: "Best Wine Ever 2023",
                   bottleImage: UIImage(named: "wine")!,
                   bottleDescription: "Bottle description text",
                   wineCountry: "Italy",
                   wineSort: "grape_sauvignon_blanc",
                   wineColor: 0,
                   wineType: 0,
                   wineSugar: 0,
                   price: "500",
                   rating: 0.0,
                   action: {})
    }
}
