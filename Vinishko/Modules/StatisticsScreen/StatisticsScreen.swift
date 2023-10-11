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
        ScrollView {
            VStack {
                PieChartView(wineTypeCounts: viewModel.wineTypeCounts, totalBottles: viewModel.totalBottles)
                    .padding()
                    .frame(width: 200, height: 200)
                
                // Преобразование словаря сортов вина в массив для сортировки
                let sortedWineSorts = viewModel.wineSorts.sorted { $0.value > $1.value }
                
                // Добавление шкал для каждого сорта вина
                ForEach(sortedWineSorts, id: \.key) { wineSort, count in
                    VStack(alignment: .leading) {
                        Text(wineSort.localize())
                            .font(.headline)
                            .padding(.leading)
                        
                        StatisticsBarView(
                            progress: CGFloat(count) / CGFloat(viewModel.totalBottles),
                            wineSortText: "\(count)"
                        )
                        .padding(.horizontal)
                    }
                }
                Spacer()
            }
            .navigationTitle("Статистика")
        }
    }
}

//#Preview {
//    StatisticsScreen(viewModel: StatisticsScreenViewModel(bottles: <#[Bottle]#>))
//}
