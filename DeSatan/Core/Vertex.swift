//
//  Vertex.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 25/06/2026.
//

import Foundation
import Algorithms


struct VertexPosition: Hashable, Equatable {
    static func == (lhs: VertexPosition, rhs: VertexPosition) -> Bool {
        if lhs.neighbors == rhs.neighbors {
            return true
        } else {
            return false
        }
    }
    
    enum DrawingNeighbor {
        case one(HexPosition)
        case two(HexPosition, HexPosition)
        case three(HexPosition, HexPosition, HexPosition)
    }
    let drawingNeighbor: DrawingNeighbor
    let neighbors: Set<HexPosition>

    func hash(into hasher: inout Hasher) {
        hasher.combine(neighbors)
    }
}


