//
//  BarChartView.swift
//  Vinishko
//
//  Created by mttm on 14.04.2023.
//

import UIKit

class PieView: UIView {
    
    // Animation properties and methods
    private var displayLink: CADisplayLink?
    private var animationStartTime: CFTimeInterval = 0
    private let animationDuration: CFTimeInterval = 1.0
    private var animationProgress: CGFloat = 0
    private let colors: [UIColor] = [.redWineColor, .whiteWineColor, .otherWineColor]
    private var values: [CGFloat] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func setValues(_ newValues: [CGFloat]) {
        self.values = newValues
        animateChart()
    }
    
    override func draw(_ rect: CGRect) {
        drawChart(rect, progress: animationProgress)
    }

    private func drawChart(_ rect: CGRect, progress: CGFloat) {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        
        var startAngle: CGFloat = -CGFloat.pi / 2
        
        for (index, value) in values.enumerated() {
            let endAngle = startAngle + 2 * CGFloat.pi * (value / values.reduce(0, +)) * progress
            let piePath = UIBezierPath()
            piePath.move(to: center)
            piePath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            piePath.close()
            colors[index % colors.count].setFill()
            piePath.fill()
            
            if progress == 1.0 && value != 0 {
                let midAngle = (startAngle + endAngle) / 2
                let textRadius = radius * 0.5
                let textPosition = CGPoint(x: center.x + textRadius * cos(midAngle),
                                           y: center.y + textRadius * sin(midAngle))
                let textAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                    .foregroundColor: UIColor.white
                ]
                let text = "\(Int(value))"
                let textSize = text.size(withAttributes: textAttributes)
                let textRect = CGRect(x: textPosition.x - textSize.width / 2,
                                      y: textPosition.y - textSize.height / 2,
                                      width: textSize.width,
                                      height: textSize.height)
                text.draw(in: textRect, withAttributes: textAttributes)
            }
            startAngle = endAngle
        }
        
        let sum = values.reduce(0, +)
        let sumText = "\(Int(sum))"
        let sumTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            .foregroundColor: UIColor.darkGray
        ]
        let sumTextSize = sumText.size(withAttributes: sumTextAttributes)
        
        let circleRadius = max(sumTextSize.width, sumTextSize.height) / 2 + 5.0
        
        let circlePath = UIBezierPath(ovalIn: CGRect(
            x: center.x - circleRadius,
            y: center.y - circleRadius,
            width: circleRadius * 2,
            height: circleRadius * 2
        ))
        UIColor.white.setFill()
        circlePath.fill()
        
        let adjustedSumTextRect = CGRect(
            x: center.x - sumTextSize.width / 2,
            y: center.y - sumTextSize.height / 2,
            width: sumTextSize.width,
            height: sumTextSize.height
        ).integral
        
        sumText.draw(in: adjustedSumTextRect, withAttributes: sumTextAttributes)
    }


    
    private func animateChart() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        animationStartTime = CACurrentMediaTime()
        animationProgress = 0
        displayLink?.add(to: .current, forMode: .common)
    }
    
    @objc private func updateAnimation() {
        let currentTime = CACurrentMediaTime()
        let elapsedTime = currentTime - animationStartTime
        animationProgress = CGFloat(elapsedTime / animationDuration)
        
        if animationProgress >= 1.0 {
            animationProgress = 1.0
            displayLink?.invalidate()
            displayLink = nil
        }
        setNeedsDisplay()
    }
}
