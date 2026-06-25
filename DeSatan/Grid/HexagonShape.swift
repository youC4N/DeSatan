//
//  HexagonShape.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 20.02.2026.
//

import SwiftUI

struct HexagonShape: Shape {
    let adjustment: CGFloat
    let size: CGFloat
    let center: CGPoint
    let vertices: [CGPoint]
    
    func path(in rect: CGRect) -> Path {
        let nextVertices = vertices[1...] + [CGPoint.hexagonVertex(for: center, with: size, at: 0)]

        var path = Path()
        guard !vertices.isEmpty,
              let firstVertex = vertices.first,
              adjustment <= 0.5
        else {
            return Path()
        }

        path.move(to: firstVertex)

        for (id, (current, next)) in zip(vertices, nextVertices).enumerated() {
            let cutoffPoint = CGPoint.interpolatedPoint(from: current, to: next, by: adjustment)

            let side = CGPoint.distance(vertices[0], vertices[1])

            let startAngle = Angle(degrees: Double(id*60))
            let endAngle = startAngle + Angle(degrees: 60)

            let cornerRadius = 1/tan(.pi/6) * adjustment * side
            let cornerAdjustment = 2 * adjustment
            let cornerCenter = CGPoint.interpolatedPoint(from: center, to: next, by: cornerAdjustment)

            path.addLine(to: cutoffPoint)
            path.addArc(
                center: cornerCenter,
                radius: cornerRadius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
        }
        return path
    }
}
