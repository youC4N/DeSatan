//
//  CGPoint+Geometry.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 20.02.2026.
//

import CoreGraphics

extension CGPoint {
    static func hexagonVertex(for center: CGPoint, with size: CGFloat, at i: Int) -> CGPoint {
        let angle = Double(60 * i - 30) * .pi/180
        return CGPoint(
            x: center.x + size*_math.cos(angle),
            y: center.y + size*sin(angle)
        )
    }

    static func interpolatedPoint(from startPoint: CGPoint, to: CGPoint, by adjustment: Double) -> CGPoint {
        return CGPoint(
            x: startPoint.x * adjustment + to.x * (1-adjustment),
            y: startPoint.y * adjustment + to.y * (1-adjustment)
        )
    }

    static func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDistance = a.x - b.x
        let yDistance = a.y - b.y
        return CGFloat(sqrt(xDistance * xDistance + yDistance * yDistance))
    }
}
