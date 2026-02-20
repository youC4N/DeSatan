//
//  ContentView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 14.02.2026.
//

import SwiftUI

func getHexVertices(center: CGPoint, size: CGFloat, i: Int) -> CGPoint {
    let angle = Double(60 * i - 30) * Double.pi/180
    return CGPoint(
        x: center.x + size*_math.cos(angle),
        y: center.y + size*sin(angle)
    )
}

func pointBeforeCurve(from startPoint: CGPoint, toPoint: CGPoint, with adjustment: Double) -> CGPoint {
    return CGPoint(
        x: startPoint.x * adjustment + toPoint.x * (1-adjustment),
        y: startPoint.y * adjustment + toPoint.y * (1-adjustment)
    )
}

func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let xDistance = a.x - b.x
    let yDistance = a.y - b.y
    return CGFloat(sqrt(xDistance * xDistance + yDistance * yDistance))
}

struct Hex: Shape {
    let size: CGFloat
    let adjustment: CGFloat
    func path(in center: CGRect) -> Path {
        let center = CGPoint(x: center.midX, y: center.midY)
        let vertices: [CGPoint] = [
            getHexVertices(center: center, size: size, i: 0),
            getHexVertices(center: center, size: size, i: 1),
            getHexVertices(center: center, size: size, i: 2),
            getHexVertices(center: center, size: size, i: 3),
            getHexVertices(center: center, size: size, i: 4),
            getHexVertices(center: center, size: size, i: 5)
        ]

        let rotatedVertices = vertices[1...] + [getHexVertices(center: center, size: size, i: 0)]

        var path = Path()
        guard !vertices.isEmpty,
              let firstVertex = vertices.first,
              adjustment <= 0.5
        else {
            return Path()
        }

        path.move(to: firstVertex)

        for (id, (current, next)) in zip(vertices, rotatedVertices).enumerated() {
            let beforeCurve = pointBeforeCurve(from: current, toPoint: next, with: adjustment)

            let side = distance(vertices[0], vertices[1])

            let startAngle = Angle(degrees: Double(id*60))
            let endAngle = startAngle + Angle(degrees: 60)

            let cornerCircleRadius = 1/tan(.pi/6) * adjustment * side
            let cornerCircleAdjustment = 2 * adjustment
            let cornerCircleCenter = pointBeforeCurve(from: center, toPoint: next, with: cornerCircleAdjustment)

            path.addLine(to: beforeCurve)
            path.addArc(
                center: cornerCircleCenter,
                radius: cornerCircleRadius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
        }
        return path
    }
}


struct ContentView: View {
    var body: some View {
        Hex(size: 100, adjustment: 0.2)
            .fill()
    }
}

#Preview {
    ContentView()
}
