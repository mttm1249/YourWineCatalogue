//
//  WaveView.swift
//  Vinishko
//
//  Created by mttm on 07.02.2023.
//

import UIKit

class WaveView: UIView {
    
    enum Direction {
        case right
        case left
    }
    
    private weak var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    
    var shapeLayer = CAShapeLayer()
    
    var speed: Double = 10
    var frequency = 7.0
    var parameterA = 1.5
    var parameterB = 35.0
    var phase = 0.0
    
    let preferredColor = UIColor.redWineColor
    
    private func startDisplayLink() {
            startTime = CACurrentMediaTime()
            self.displayLink?.invalidate()
            let displayLink = CADisplayLink(target: self, selector:#selector(handleDisplayLink(_:)))
            displayLink.add(to: .main, forMode: .common)
            self.displayLink = displayLink
    }
    
    @objc private func handleDisplayLink(_ displayLink: CADisplayLink) {
        self.phase = (CACurrentMediaTime() - startTime) * self.speed
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.setNeedsDisplay()
    }
        
    func animationStart(direction: Direction, speed: Double) {
        if direction == .right {
            self.speed = -speed
        } else {
            self.speed = speed
        }
        self.startDisplayLink()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        shapeLayer.frame = rect
        let width = Double(self.frame.width)
        let height = Double(self.frame.height)
        
        let mid = height * 0.5
        
        let waveLength = width / self.frequency
        let waveHeightCoef = Double(self.frequency)
        path.move(to: CGPoint(x: 0, y: self.frame.maxY))
        path.addLine(to: CGPoint(x: 0, y: mid))
        
        for x in stride(from: 0, through: width, by: 1) {
            let actualX = x / waveLength
            let sine = -cos(self.parameterA*(actualX + self.phase)) * sin((actualX + self.phase)/self.parameterB)
            let y = waveHeightCoef * sine + mid
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: CGFloat(width), y: self.frame.maxY))
        path.addLine(to: CGPoint(x: 0, y: self.frame.maxY))
        
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = preferredColor.cgColor
        shapeLayer.strokeColor = preferredColor.cgColor
        self.layer.addSublayer(self.shapeLayer)
    }
}
