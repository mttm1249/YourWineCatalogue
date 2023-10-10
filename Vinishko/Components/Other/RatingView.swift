//
//  ratingView.swift
//  Vinishko
//
//  Created by mttm on 09.09.2023.
//

import SwiftUI

struct RatingView: View {
    @Binding var selectedRating: Double {
        didSet {
            if selectedRating != oldValue {
                HapticFeedbackService.generateFeedback(style: .light)
            }
        }
    }
    let totalSegments: Int = 10
    let spacing: CGFloat = 1
    let step: CGFloat = 0.5
    
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
                    Text("\(selectedRating, specifier: "%.1f")")
                        .font(.system(size: 14)).bold()
                }
            }
            
            HStack(spacing: spacing) {
                ForEach(0..<totalSegments, id: \.self) { index in
                    let targetRating = step * CGFloat(index + 1)
                    let isActive = selectedRating >= targetRating
                    let isLastActive = selectedRating == targetRating
                    
                    Rectangle()
                        .foregroundColor(isActive ? Pallete.mainColor : Pallete.segmentPickerBg)
                        .frame(width: segmentWidth, height: isLastActive ? 35 : 30)
                        .clipShape(RoundedSpecificCorner(radius: 8, corners: index == 0 ? [.topLeft, .bottomLeft] : index == totalSegments - 1 ? [.topRight, .bottomRight] : []))
                        .onTapGesture {
                            if selectedRating == targetRating {
                                selectedRating = targetRating - step
                            } else {
                                selectedRating = targetRating
                            }
                            selectedRating = max(0, min(5, selectedRating))
                        }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let calculatedSegment = min(totalSegments, max(0, Int((value.location.x) / (segmentWidth + spacing))))
                        let newRating = step * CGFloat(calculatedSegment + 1)
                        selectedRating = max(0, min(5, newRating))
                    }
            )
            .frame(minHeight: 35)
        }
        .padding(.horizontal, 16)
    }
}

struct RoundedSpecificCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(selectedRating: .constant(4))
    }
}
