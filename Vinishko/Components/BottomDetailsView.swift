//
//  BottomDetailsView.swift
//  Vinishko
//
//  Created by mttm on 09.09.2023.
//

import SwiftUI

struct BottomDetailsView: View {
    
    var descriptionText: String
    var grapeVarieties: String
    var placeOfPurchaseInfo: String
    var priceInfo: String
    var rating: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Рейтинг: \(rating)/5")
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.orange)
                }
                Text("Куплено в: \(placeOfPurchaseInfo)")
                Text("Цена: \(priceInfo)₽")
                Text("Сорт: \(grapeVarieties)")
                Text("Комментарий: \(descriptionText)")
            }
            .padding()
        }
        .background(Pallete.segmentPickerBg)
//        .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
        .padding(.horizontal, 16)
    }
}

struct BottomDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BottomDetailsView(descriptionText: "",
                          grapeVarieties: "",
                          placeOfPurchaseInfo: "",
                          priceInfo: "", rating: "")
    }
}
