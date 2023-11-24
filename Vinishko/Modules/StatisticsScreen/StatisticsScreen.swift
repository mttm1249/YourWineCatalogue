//
//  StatisticsScreen.swift
//  Vinishko
//
//  Created by mttm on 08.10.2023.
//

import SwiftUI

struct StatisticsScreen: View {
    
    @StateObject var viewModel: StatisticsScreenViewModel
    @State private var showingAllWineSorts = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                PieChartView(wineTypeCounts: viewModel.wineTypeCounts, totalBottles: viewModel.totalBottles)
                    .padding()
                    .frame(width: 200, height: 200)
                
                // Преобразование словаря сортов вина в массив для сортировки
                let sortedWineSorts = viewModel.wineSorts.sorted { $0.value > $1.value }
                
                // Получение максимального значения для сортов вина
                let maxCount = sortedWineSorts.first?.value ?? 1
                
                if !showingAllWineSorts {
                    HStack {
                        Text(Localizable.StatisticsScreenModule.top)
                            .font(Fonts.bold28)
                            .padding()
                        Spacer()
                    }
                }
                
                ForEach(Array(sortedWineSorts.prefix(showingAllWineSorts ? sortedWineSorts.count : 10)), id: \.key) { wineSort, count in
                    VStack {
                        StatisticsBarView(
                            progress: CGFloat(count) / CGFloat(maxCount),
                            sortsCount: "\(count)",
                            wineSortName: wineSort.localize()
                        )
                        .padding(.bottom, 12)
                    }
                }
                
                if !showingAllWineSorts {
                    Button(Localizable.StatisticsScreenModule.showAll) {
                        showingAllWineSorts = true
                    }
                    .padding()
                }
            }
            .navigationTitle(Localizable.StatisticsScreenModule.statisticsTitle).navigationBarTitleDisplayMode(.inline)
        }
    }
}
