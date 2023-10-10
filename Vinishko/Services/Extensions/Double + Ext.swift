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
            return String(format: "%.1f", self)
        }
    }
}

extension Double {
    var stringWithoutTrailingZeroes: String {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2 // максимальное количество десятичных знаков
        return nf.string(from: NSNumber(value: self)) ?? ""
    }
}
