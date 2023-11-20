//
//  PieChartView.swift
//  Vinishko
//
//  Created by mttm on 08.10.2023.
//

import SwiftUI

struct PieChartView: View {
    var wineTypeCounts: [Int]
    var totalBottles: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(wineTypeCounts.indices, id: \.self) { index in
                    let start = self.angle(forValue: self.sumUpTo(index: index))
                    let end = self.angle(forValue: self.sumUpTo(index: index) + CGFloat(self.wineTypeCounts[index]))
                    PieSlice(startAngle: start, endAngle: end)
                        .fill(self.color(for: index))
                        .overlay(
                            GeometryReader { sliceGeometry in
                                // Если количество записей больше 0, отображаем число
                                if self.wineTypeCounts[index] > 0 {
                                    let midAngle = (start.radians + end.radians) / 2
                                    let labelRadius = min(sliceGeometry.size.width, sliceGeometry.size.height) / 4
                                    let x = sliceGeometry.size.width / 2 + labelRadius * CGFloat(cos(midAngle))
                                    let y = sliceGeometry.size.height / 2 + labelRadius * CGFloat(sin(midAngle))
                                    Text("\(self.wineTypeCounts[index])")
                                        .position(x: x, y: y)
                                        .font(.system(size: 14))
                                        .foregroundColor(Pallete.ratingBg)
                                        .zIndex(1)
                                }
                            }
                        )
                }
                Text("\(totalBottles)")
                    .font(.system(size: 14)).bold()
                    .foregroundColor(Pallete.textColor)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(Pallete.ratingBg)
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                    )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func sumUpTo(index: Int) -> CGFloat {
        var sum: CGFloat = 0
        for i in 0..<index {
            sum += CGFloat(self.wineTypeCounts[i])
        }
        return sum
    }
    
    private func color(for index: Int) -> Color {
        let colors: [Color] = [Pallete.redWineColor, Pallete.whiteWineColor, Pallete.otherWineColor]
        return colors[index % colors.count]
    }
    
    private func angle(forValue value: CGFloat) -> Angle {
        return Angle(radians: Double(value / CGFloat(self.totalBottles) * 2 * CGFloat.pi) - .pi/2)
    }
}

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}

//struct PieChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        PieChartView(values: [25, 30, 44])
//    }
//}
