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
}
