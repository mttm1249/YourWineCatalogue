//
//  DownloadProgressView.swift
//  Vinishko
//
//  Created by mttm on 18.11.2023.
//

import SwiftUI

struct DownloadProgressView: View {
    var progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .foregroundColor(Pallete.segmentPickerBg)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(Pallete.redWineColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
        }
        .frame(width: 130, height: 130)
    }
}

#Preview {
    DownloadProgressView(progress: 0.6)
}
