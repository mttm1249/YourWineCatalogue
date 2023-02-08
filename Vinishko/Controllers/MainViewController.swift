//
//  MainViewController.swift
//  Vinishko
//
//  Created by Денис on 02.10.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var savedAlertLabel: UILabel!
    @IBOutlet weak var waveView: WaveView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedAlertLabel.isHidden = true
        if !userDefaults.bool(forKey: "qrSettings") {
            setDefaultSettingsForQR()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        waveView.animationStart(direction: .right, speed: 4)
    }
      
    // Set default settings for QR (first start)
    private func setDefaultSettingsForQR() {
        userDefaults.set(true, forKey: "qrSettings")
        userDefaults.set(true, forKey: "shareImage")
        userDefaults.set(true, forKey: "shareComment")
        userDefaults.set(true, forKey: "shareRating")
    }
    
    // Delay for label animation
    func delay(_ delay: Double, closure: @escaping() -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            closure()
        }
    }
    
    func animationLabel() {
        delay(1.5) {
            self.savedAlertLabel.fadeOut()
        }
        self.savedAlertLabel.isHidden = false
        savedAlertLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UILabel.animate(withDuration: 0.7,
                        delay: 0,
                        usingSpringWithDamping: CGFloat(10.0),
                        initialSpringVelocity: CGFloat(20.0),
                        options: UILabel.AnimationOptions.allowUserInteraction,
                        animations: {
            self.savedAlertLabel.transform = CGAffineTransform.identity
        },
                        completion: { Void in()  }
        )
        self.savedAlertLabel.fadeIn()
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        animationLabel()
    }
}

// MARK: UILabel Animation

extension UILabel {
    func fadeIn(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
}
