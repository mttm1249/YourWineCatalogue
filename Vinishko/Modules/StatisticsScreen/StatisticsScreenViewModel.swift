//
//  StatisticsScreenViewModel.swift
//  Vinishko
//
//  Created by mttm on 08.10.2023.
//

import SwiftUI

final class StatisticsScreenViewModel: ObservableObject {
    @Published var bottles: [Bottle]
    
    init(bottles: [Bottle]) {
        self.bottles = bottles
    }
    
    var totalBottles: Int {
        return bottles.count
    }
    
    var wineTypeCounts: [Int] {
        let redWineCount = bottles.filter { $0.wineColor == 0 }.count
        let whiteWineCount = bottles.filter { $0.wineColor == 1 }.count
        let otherWineCount = bottles.filter { $0.wineColor == 2 }.count
        
        return [redWineCount, whiteWineCount, otherWineCount]
    }

    // Метод для получения списка сортов вин с учетом разделения строк
    var wineSorts: [String: Int] {
        var sortsCount: [String: Int] = [:]

        bottles.forEach { bottle in
            // Разделение строки сортов на отдельные сорта
            let sorts = bottle.wineSort?.split(separator: ",").compactMap {
                String($0)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            // Подсчет количества каждого сорта
            sorts?.forEach { sort in
                sortsCount[sort, default: 0] += 1
            }
        }

        return sortsCount
    }
    
}
