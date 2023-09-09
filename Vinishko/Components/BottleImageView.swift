//
//  BottleImageView.swift
//  Vinishko
//
//  Created by mttm on 08.09.2023.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct BottleImageView: View {
    
    var image: UIImage
    
    var body: some View {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                    .frame(height: 350)

            }
        .padding(.horizontal, 16)
    }
}

struct BottleImageView_Previews: PreviewProvider {
    static var previews: some View {
        BottleImageView(image: UIImage(named: "wine")!)
    }
}
