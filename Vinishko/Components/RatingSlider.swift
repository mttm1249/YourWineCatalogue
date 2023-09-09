//
//  RatingSlider.swift
//  Vinishko
//
//  Created by mttm on 09.09.2023.
//

import SwiftUI

struct RatingPicker: View {
    @Binding var selectedRating: Double
    let minValue: Double = 0
    let maxValue: Double = 5
    let step: Double = 0.25
    let totalHeight: CGFloat = 30
    let cornerRadius: CGFloat = 8.0
    let tickHeight: CGFloat = 30
    let tickWidth: CGFloat = 1
    let sidePadding: CGFloat = 16
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width - 32
    
    @State private var prevRating: Double = 0
    
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
            
            ZStack(alignment: .leading) {
                createSegment(from: minValue, to: maxValue, withColor: Pallete.segmentPickerBg)
                createSegment(from: minValue, to: selectedRating, withColor: Pallete.mainColor)
                createTicks(from: minValue, to: maxValue)
            }
            .frame(width: screenWidth, height: totalHeight)
            .cornerRadius(cornerRadius)
            .gesture(DragGesture(minimumDistance: 0).onChanged(onDragChanged))
        }
        .padding(.horizontal, sidePadding)
    }
    
    private func onDragChanged(drag: DragGesture.Value) {
        let totalSegments = Int((maxValue - minValue) / step)
        let segmentWidth = screenWidth / CGFloat(totalSegments)
        let newValue = Double(drag.location.x / segmentWidth) * step
        let roundedValue = min(maxValue, max(minValue, Double(round(4 * newValue) / 4)))
        
        if roundedValue != prevRating {
           HapticFeedbackService.generateFeedback(style: .light)
            prevRating = roundedValue
        }
        
        selectedRating = roundedValue
    }
    
    private func createSegment(from startValue: Double, to endValue: Double, withColor color: Color) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(stride(from: startValue, through: endValue, by: step)), id: \.self) { value in
                Rectangle()
                    .frame(width: (screenWidth / CGFloat((maxValue - minValue) / step)), height: totalHeight)
                    .foregroundColor(color)
            }
        }
    }
    
    private func createTicks(from startValue: Double, to endValue: Double) -> some View {
        HStack(spacing: (screenWidth / CGFloat((maxValue - minValue) / step)) - tickWidth) {
            ForEach(Array(stride(from: startValue, through: endValue, by: step)), id: \.self) { value in
                Rectangle()
                    .frame(width: tickWidth, height: tickHeight)
                    .foregroundColor(Color.gray).opacity(0.2)
            }
        }
    }
}

struct RatingPicker_Previews: PreviewProvider {
    static var previews: some View {
        RatingPicker(selectedRating: .constant(0))
    }
}
