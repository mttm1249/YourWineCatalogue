//
//  StatisticsScreen.swift
//  Vinishko
//
//  Created by mttm on 08.10.2023.
//

import SwiftUI

struct StatisticsScreen: View {
    
    @StateObject var viewModel: StatisticsScreenViewModel
    
    var body: some View {
        VStack {
            PieChartView(wineTypeCounts: viewModel.wineTypeCounts, totalBottles: viewModel.totalBottles)
                .padding()
                .frame(width: 200, height: 200)
            Spacer()
        }
    }
}



//#Preview {
//    StatisticsScreen(viewModel: StatisticsScreenViewModel())
//}
