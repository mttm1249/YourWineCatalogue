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
    var wineSortText: String

    var body: some View {
        ZStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Pallete.segmentPickerBg)
                    .frame(height: 20)

                RoundedRectangle(cornerRadius: 10)
                    .fill(Pallete.redWineColor)
                    .frame(width: self.currentProgress * UIScreen.main.bounds.width, height: 20)
                    .animation(.linear, value: currentProgress)
            }
            .frame(maxWidth: UIScreen.main.bounds.width)

            Text(wineSortText)
                .foregroundColor(.white)
                .padding(.leading, 16)
        }
        .onAppear {
            self.currentProgress = progress
        }
    }
}

#Preview {
    StatisticsBarView(progress: 0.5, wineSortText: "test")
        .padding()
}
