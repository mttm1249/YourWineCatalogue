//
//  Time.swift
//  Vinishko
//
//  Created by Денис on 02.10.2022.
//

import Foundation

class Time {
        
    func getData() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
//        dateFormatter.locale = Locale(identifier: "ru_RU")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
