//
//  CircleImageView.swift
//  Vinishko
//
//  Created by mttm on 07.07.2023.
//

import SwiftUI

struct CircleImageView: View {
    var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
    }
}
