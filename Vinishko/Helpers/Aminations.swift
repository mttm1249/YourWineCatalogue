//
//  Aminations.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import UIKit

class Animations {
    static func animate(_ label: UILabel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            label.fadeOut()
        }
        label.isHidden = false
        label.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UILabel.animate(withDuration: 0.7,
                        delay: 0,
                        usingSpringWithDamping: CGFloat(10.0),
                        initialSpringVelocity: CGFloat(20.0),
                        options: UILabel.AnimationOptions.allowUserInteraction,
                        animations: {
            label.transform = CGAffineTransform.identity
        },
                        completion: { Void in()  }
        )
        label.fadeIn()
    }
}
