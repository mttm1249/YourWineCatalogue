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
    var wineSortName: String 

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(wineSortName)
                .font(Fonts.bold14)
                .padding(.leading, 16)

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
                        .font(Fonts.bold12)
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

