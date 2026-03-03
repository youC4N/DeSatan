//
//  VertexGeometry.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 03.03.2026.
//

import Foundation

struct VertexGeometry {
    let allVertices: [CGPoint]

    init(hexCenters: [CGPoint], hexSize: CGFloat, hexSpacing: CGFloat) {
        let realSize = hexSize + hexSpacing
        self.allVertices = Array(Set(hexCenters.flatMap { center in
            HexagonGeometry(size: realSize, center: center).vertices
        }))
    }
}

