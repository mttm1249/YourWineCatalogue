//
//  BottomDetailsView.swift
//  Vinishko
//
//  Created by mttm on 09.09.2023.
//

import SwiftUI

enum DetailsType {
    case info
    case location
    case purchase
    case comment
}

struct BottomDetailsView: View {
    private let headerColor = Color.gray
    
    var activeType: DetailsType
    
    var wineColor: Int16 = 0
    var wineCountry: String = ""
    var wineRegion: String = ""
    var wineSugar: Int16 = 0
    var wineType: Int16 = 0
    var price: String = ""
    var placeOfPurchaseInfo: String = ""
    var bottleDescription: String = ""
    
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
    
    private func getWineColorName() -> String {
        switch wineColor {
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
    
    private func getWineSugar() -> String {
        switch wineSugar {
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
        switch activeType {
        case .info:
            VStack(alignment: .leading) {
                Text("Описание")
                    .font(.system(size: 14)).bold()
                    .foregroundColor(headerColor)
                HStack(spacing: 8) {
                    Text(getWineColorName())
                        .font(.system(size: 14))
                        .foregroundColor(Pallete.textColor)
                        .frame(height: 20)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(getWineColor(), lineWidth: 2)
                        )
                    Text(getWineSugar())
                        .font(.system(size: 14))
                        .foregroundColor(Pallete.textColor)
                        .frame(height: 20)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.gray, lineWidth: 1)
                        )
                    Text(getWineType())
                        .font(.system(size: 14))
                        .foregroundColor(Pallete.textColor)
                        .frame(height: 20)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.gray, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 16)
        case .purchase:
            VStack(alignment: .leading) {
                Text("Покупка")
                    .font(.system(size: 14)).bold()
                    .foregroundColor(headerColor)
                HStack(spacing: 8) {
                    Text(placeOfPurchaseInfo)
                        .font(.system(size: 14))
                        .foregroundColor(Pallete.textColor)
                        .frame(height: 20)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.gray, lineWidth: 1)
                        )
                    Text("\(price)₽")
                        .font(.system(size: 14))
                        .foregroundColor(Pallete.textColor)
                        .frame(height: 20)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.gray, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 16)
        case .location:
            VStack(alignment: .leading) {
                Text("Происхождение")
                    .font(.system(size: 14)).bold()
                    .foregroundColor(headerColor)
                HStack(spacing: 8) {
                    Text(wineCountry)
                        .font(.system(size: 14))
                        .foregroundColor(Pallete.textColor)
                        .frame(height: 20)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.gray, lineWidth: 1)
                        )
                    Text(wineRegion)
                        .font(.system(size: 14))
                        .foregroundColor(Pallete.textColor)
                        .frame(height: 20)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.gray, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 16)
        case .comment:
            VStack(alignment: .leading, spacing: 8) {
                Text("Комментарий")
                    .font(.system(size: 14)).bold()
                    .foregroundColor(headerColor)
                    Text(bottleDescription)
                        .font(.system(size: 14))
            }
            .padding(.horizontal, 16)
        }
    }
}

struct BottomDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BottomDetailsView(activeType: .comment, bottleDescription: "Text")
    }
}
