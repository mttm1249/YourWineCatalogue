//
//  NewBottleScreenViewModel.swift
//  Vinishko
//
//  Created by mttm on 17.09.2023.
//

import UIKit

class NewBottleScreenViewModel: ObservableObject {
   
    func cropToSquare(image original: UIImage) -> UIImage? {
        if let imageRef = original.cgImage {
            return UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: original.imageOrientation)
        } else {
            return nil
        }
    }
}
