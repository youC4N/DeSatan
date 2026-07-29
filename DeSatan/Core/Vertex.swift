//
//  Vertex.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 25/06/2026.
//

import Foundation
import Algorithms


struct VertexPosition {
    enum DrawingNeighbor {
        case one(HexPosition)
        case two(HexPosition, HexPosition)
        case three(HexPosition, HexPosition, HexPosition)
    }
    let drawingNeighbor: DrawingNeighbor
    let neighbors: Set<HexPosition>
}

extension VertexPosition: Hashable {
    static func == (lhs: VertexPosition, rhs: VertexPosition) -> Bool {
        if lhs.neighbors == rhs.neighbors {
            return true
        } else {
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(neighbors)
    }
}
