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
    var onImageTap: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 250)
                .clipped()
                .contentShape(Rectangle())
                .onTapGesture {
                    onImageTap()
                }

            HStack(spacing: 2) {
                Text(rating)
                    .font(.system(size: 12)).bold()
                Image(systemName: Images.star)
                    .foregroundColor(.orange)
                    .font(.system(size: 12))
            }
            .padding(8)
            .background(Capsule().fill(Pallete.ratingBg))
            .padding(8)
        }
    }
}
