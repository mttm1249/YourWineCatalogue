//
//  Double + Ext.swift
//  Vinishko
//
//  Created by mttm on 09.09.2023.
//

import Foundation

extension Double {
    var smartDescription: String {
        let intValue = Int(self)
        if Double(intValue) == self {
            return "\(intValue)"
        } else {
            return String(format: "%.2f", self)
        }
    }
}
