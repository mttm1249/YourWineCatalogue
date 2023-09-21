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
                .padding()
            Spacer()
            VStack(alignment: .leading) {
                Text("Дата дегустации")
                    .font(.system(size: 14)).bold()
                    .foregroundColor(.gray)
                Text(tastingDate)
                    .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
                Image(uiImage: getImage(from: bottle))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

extension BottlePhotoView {
    func getImage(from bottle: Bottle) -> UIImage {
        guard let imageData = bottle.bottleImage, let uiImage = UIImage(data: imageData) else {
            return UIImage(named: "addImage") ?? UIImage()
        }
        return uiImage
    }
}
