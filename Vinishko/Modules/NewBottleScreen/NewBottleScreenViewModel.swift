//
//  NewBottleScreenViewModel.swift
//  Vinishko
//
//  Created by mttm on 17.09.2023.
//

import UIKit

class NewBottleScreenViewModel: ObservableObject {
   
    func cropToSquare(image original: UIImage) -> UIImage? {
        let positionX: CGFloat
        let positionY: CGFloat
        let width: CGFloat
        let height: CGFloat

        if original.size.width > original.size.height {
            positionX = ((original.size.width - original.size.height) / 2.0)
            positionY = 0.0
            width = original.size.height
            height = original.size.height
        } else {
            positionX = 0.0
            positionY = ((original.size.height - original.size.width) / 2.0)
            width = original.size.width
            height = original.size.width
        }

        let cropSquare = CGRect(x: positionX, y: positionY, width: width, height: height)

        if let imageRef = original.cgImage?.cropping(to: cropSquare) {
            return UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: original.imageOrientation)
        } else {
            return nil
        }
    }
}
