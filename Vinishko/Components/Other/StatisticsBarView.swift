//
//  StatisticsBarView.swift
//  Vinishko
//
//  Created by mttm on 11.10.2023.
//

import SwiftUI

struct StatisticsBarView: View {
    @State private var currentProgress: CGFloat = 0.0
    var progress: CGFloat
    var sortsCount: String
    var wineSortName: String  // Добавленный параметр для названия сорта вина

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {  // VStack используется для вертикального стека с отступом 8pt
            Text(wineSortName)  // Этот текст будет отображаться над шкалой
                .font(.system(size: 14)).bold()
                .foregroundColor(.gray)
                .padding(.leading, 16)  // Отступ слева для выравнивания с шкалой

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Pallete.segmentPickerBg)
                        .frame(height: 20)

                    RoundedRectangle(cornerRadius: 10)
                        .fill(Pallete.redWineColor)
                        .frame(width: self.currentProgress * (geometry.size.width - 32), height: 20)
                        .animation(.linear, value: currentProgress)

                    Text(sortsCount)
                        .font(.system(size: 12)).bold()
                        .foregroundColor(.white)
                        .padding(.leading)
                }
                .padding(.horizontal, 16)
            }
        }
        .onAppear {
            self.currentProgress = progress
        }
    }
}

