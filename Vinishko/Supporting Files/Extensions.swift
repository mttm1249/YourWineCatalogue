//
//  Extensions.swift
//  Vinishko
//
//  Created by Денис on 03.10.2022.
//

import UIKit

// MARK: - Global
let feedbackGenerator = UIImpactFeedbackGenerator()
let userDefaults = UserDefaults.standard

// MARK: - Hide Keyboard Method
extension UIViewController {
    func hideKeyboard() {        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
