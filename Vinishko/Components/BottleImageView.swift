//
//  BottleImageView.swift
//  Vinishko
//
//  Created by mttm on 08.09.2023.
//

import SwiftUI

struct BottleImageView: View {
    var image: UIImage
    var rating: String
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 250)
                .clipped()
           
            HStack(spacing: 2) {
                Text(rating)
//                    .foregroundColor(.white)
                    .font(.system(size: 12)).bold()

                Image(systemName: "star.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 12))
            }
            .padding(8)
            .background(Capsule().fill(Pallete.ratingBg))
//            .overlay(
//                Capsule()
//                    .stroke(Color.white, lineWidth: 2))
            .padding(8)
        }
    }

}

struct BottleImageView_Previews: PreviewProvider {
    static var previews: some View {
        BottleImageView(image: UIImage(named: "wine")!, rating: "4.25")
    }
}
