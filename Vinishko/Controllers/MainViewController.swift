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
        waveView.animationStart(direction: .right, speed: 4)
        savedAlertLabel.isHidden = true
    }
        
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        Animations.animate(savedAlertLabel)
    }
}
