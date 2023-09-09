//
//  ratingView.swift
//  Vinishko
//
//  Created by mttm on 09.09.2023.
//


import SwiftUI

struct RatingView: View {
    @Binding var selectedRating: Double
    let totalSegments: Int = 20
    let spacing: CGFloat = 1
    let step: CGFloat = 0.25
    
    var segmentWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing = CGFloat(totalSegments - 1) * spacing
        return (screenWidth - 48 - totalSpacing) / CGFloat(totalSegments)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Рейтинг")
                    .font(.system(size: 14)).bold()
                Spacer()
                if selectedRating <= 0 {
                    Text("Без рейтинга")
                        .font(.system(size: 14)).bold()
                        .foregroundColor(.gray)
                } else {
                    Text("\(selectedRating, specifier: "%.2f")")
                        .font(.system(size: 14)).bold()
                }
            }
            HStack(spacing: spacing) {
                ForEach(0..<totalSegments, id: \.self) { index in
                    let isActive = selectedRating >= step * CGFloat(index + 1)
                    let isLastActive = Int(selectedRating / step) == (index + 1)
                    Rectangle()
                        .foregroundColor(isActive ? Pallete.mainColor : Pallete.segmentPickerBg)
                        .frame(width: segmentWidth, height: isLastActive ? 35 : 30)
                        .onTapGesture {
                            selectedRating = isActive ? step * CGFloat(index) : step * CGFloat(index + 1)
                            HapticFeedbackService.generateFeedback(style: .light)
                        }
                }
            }
            .frame(minHeight: 35)
            .mask(RoundedRectangle(cornerRadius: 8))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let calculatedSegment = min(totalSegments, max(0, Int((value.location.x - 16) / (segmentWidth + spacing))))
                        let newRating = step * CGFloat(calculatedSegment)
                        if newRating != selectedRating {
                            HapticFeedbackService.generateFeedback(style: .light)
                        }
                        selectedRating = newRating
                    }
            )
        }
        .padding(.horizontal, 24)
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(selectedRating: .constant(4))
    }
}
