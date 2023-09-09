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
    var body: some View {
        ScrollView {
            VStack(spacing: -5) {
                Image("wine")
                    .resizable()
                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                    .frame(height: 350)
                ZStack(alignment: .topLeading) {
                          Rectangle()
                              .fill(Color.blue)
                              .frame(maxWidth: .infinity)
                    VStack {
                        Text("Привет, Олег!")
                            .foregroundColor(.white)
                    }
                    .padding()
                      }
                .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
                .frame(height: 350)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct BottleImageView_Previews: PreviewProvider {
    static var previews: some View {
        BottleImageView()
    }
}
