//
//  QRViewController.swift
//  Vinishko
//
//  Created by Денис on 26.01.2023.
//

import UIKit

class QRViewController: UIViewController {
    
    var generatedQRImage: UIImage!
    let currentBrightness = UIScreen.main.brightness
    
    @IBOutlet weak var qrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIScreen.main.brightness = 1
        qrImage.image = generatedQRImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIScreen.main.brightness = currentBrightness
    }
}
