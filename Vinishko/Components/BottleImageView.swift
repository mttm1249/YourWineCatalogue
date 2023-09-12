//
//  BottleImageView.swift
//  Vinishko
//
//  Created by mttm on 08.09.2023.
//

import SwiftUI

//struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect,
//                                byRoundingCorners: corners,
//                                cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}


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

