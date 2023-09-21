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
        let value = NSLocalizedString(self, comment: comment)
        if value != self || NSLocale.preferredLanguages.first == defaultLanguage {
            return value
        }
        guard let path = Bundle.main.path(forResource: defaultLanguage, ofType: "lproj"), let bundle = Bundle(path: path) else {
            return value
        }

        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}