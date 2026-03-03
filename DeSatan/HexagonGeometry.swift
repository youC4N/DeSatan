//
//  HexagonGeometry.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 03.03.2026.
//

import Foundation

struct HexagonGeometry {
    let size: Double
    let center: CGPoint
    let vertices: [CGPoint]

    init(size: Double, center: CGPoint) {
        self.size = size
        self.center = center
        self.vertices = [
            CGPoint.hexagonVertex(for: center, with: size, at: 0),
            CGPoint.hexagonVertex(for: center, with: size, at: 1),
            CGPoint.hexagonVertex(for: center, with: size, at: 2),
            CGPoint.hexagonVertex(for: center, with: size, at: 3),
            CGPoint.hexagonVertex(for: center, with: size, at: 4),
            CGPoint.hexagonVertex(for: center, with: size, at: 5)
        ]
    }

}
