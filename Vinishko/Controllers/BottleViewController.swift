//
//  BottleViewController.swift
//  Vinishko
//
//  Created by Денис on 20.11.2022.
//

import UIKit
import RealmSwift

class BottleViewController: UIViewController {
    
    var currentBottle: Bottle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentBottle != nil {
            view.backgroundColor = .red
        }
    }
    
}
