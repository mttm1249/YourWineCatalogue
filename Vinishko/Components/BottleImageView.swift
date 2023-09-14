//
//  BottleImageView.swift
//  Vinishko
//
//  Created by mttm on 08.09.2023.
//

import SwiftUI

struct BottleImageView: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 250)
            .clipped()
    }
}

struct BottleImageView_Previews: PreviewProvider {
    static var previews: some View {
        BottleImageView(image: UIImage(named: "wine")!)
    }
}
