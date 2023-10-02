//
//  BottlePhotoView.swift
//  Vinishko
//
//  Created by mttm on 16.09.2023.
//

import SwiftUI

struct BottlePhotoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var bottle: Bottle
    var tastingDate: String
    var image: UIImage
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.top, 16)
            Spacer()
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Дата дегустации")
                        .font(.system(size: 14)).bold()
                        .foregroundColor(.gray)
                    Text(tastingDate)
                        .font(.system(size: 14))
                }
                .padding(.horizontal, 16)
                if let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

extension Image {
    func getImage(from bottle: Bottle) -> UIImage {
        guard let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) else {
            return UIImage(named: "addImage") ?? UIImage()
        }
        return uiImage
    }
}
