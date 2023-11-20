//
//  SegmentedControl.swift
//  Vinishko
//
//  Created by mttm on 28.08.2023.
//

import SwiftUI

struct SegmentedControl: View {
    @Binding var selectedSegment: Int
    let titles: [String]
    
    private struct Constants {
        static let cornerRadius: CGFloat = 8
        static let segmentHeight: CGFloat = 18
        static let borderLineWidth: CGFloat = 0.5
        static let hStackSpacing: CGFloat = 11
        static let verticalPadding: CGFloat = 5
        static let frameMinWidth: CGFloat = 0
    }
    
    private func colorForSegment(at index: Int) -> Color {
        if selectedSegment == index {
            switch index {
            case 0:
                return Pallete.redWineColor
            case 1:
                return Pallete.whiteWineColor
            case 2:
                return Pallete.otherWineColor
            default:
                return Pallete.redWineColor
            }
        } else {
            return .clear
        }
    }
    
    private func borderColorForSegment(at index: Int) -> Color {
        return selectedSegment == index ? .clear : .gray
    }
    
    var body: some View {
        HStack(spacing: Constants.hStackSpacing) {
            ForEach(titles.indices, id: \.self) { index in
                Button(action: {
                    if selectedSegment == index {
                        // Отменить выбор
                        selectedSegment = -1
                    } else {
                        // Установить новый выбранный сегмент
                        selectedSegment = index
                    }
                    HapticFeedbackService.generateFeedback(style: .light)
                }) {
                    Text(titles[index])
                        .font(Fonts.regular12)
                        .frame(minWidth: Constants.frameMinWidth, maxWidth: .infinity)
                        .padding(.vertical, Constants.verticalPadding)
                        .background(
                            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                .fill(colorForSegment(at: index))
                        )
                        .foregroundColor(selectedSegment == index ? .white : .gray)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                .stroke(borderColorForSegment(at: index), lineWidth: Constants.borderLineWidth)
                        )
                }
            }
        }
        .frame(height: Constants.segmentHeight)
    }
}

struct SegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControl(selectedSegment: .constant(0), titles: ["Красное", "Белое", "Другие"])
    }
}
