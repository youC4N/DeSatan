//
//  HexagonShape.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 20.02.2026.
//

import SwiftUI

struct Hex: Shape {
    let position: HexPosition
    let adjustment: CGFloat
    func path(in rect: CGRect) -> Path {
        let size: CGFloat = (rect.width-10*1)/(5*sqrt(3))
        let hexCenter: CGPoint = getHexCenter(for: size, at: position) + CGPoint(x: rect.midX, y: rect.midY)
        let vertices: [CGPoint] = [
            CGPoint.hexagonVertex(for: hexCenter, with: size, at: 0),
            CGPoint.hexagonVertex(for: hexCenter, with: size, at: 1),
            CGPoint.hexagonVertex(for: hexCenter, with: size, at: 2),
            CGPoint.hexagonVertex(for: hexCenter, with: size, at: 3),
            CGPoint.hexagonVertex(for: hexCenter, with: size, at: 4),
            CGPoint.hexagonVertex(for: hexCenter, with: size, at: 5)
        ]
        let nextVertices = vertices[1...] + [CGPoint.hexagonVertex(for: hexCenter, with: size, at: 0)]

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
            let cornerCenter = CGPoint.interpolatedPoint(from: hexCenter, to: next, by: cornerAdjustment)

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
    private func getHexCenter(for size: Double, at position: HexPosition) -> CGPoint {
        let x = sqrt(3)/2  * Double(position.column)
        let y = 3.0/2 * Double(position.row)

        return CGPoint(x: (size+1) * x, y: (size+1) * y)
    }
}
