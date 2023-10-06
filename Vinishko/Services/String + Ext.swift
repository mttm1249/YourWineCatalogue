//
//  String + Ext.swift
//  Vinishko
//
//  Created by mttm on 01.09.2023.
//

import UIKit

extension String {
    func localize(comment: String = "") -> String {
        let defaultLanguage = "ru"
        
        let components = self.components(separatedBy: ", ")
        let localizedComponents = components.map { component -> String in
            let localizedValue = NSLocalizedString(component, comment: comment)
            if localizedValue != component || NSLocale.preferredLanguages.first == defaultLanguage {
                return localizedValue
            }
            guard let path = Bundle.main.path(forResource: defaultLanguage, ofType: "lproj"), let bundle = Bundle(path: path) else {
                return localizedValue
            }
            return NSLocalizedString(component, bundle: bundle, comment: "")
        }
        
        return localizedComponents.joined(separator: ", ")
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
