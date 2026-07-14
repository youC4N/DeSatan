//
//  Hexagon.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 20.03.2026.
//

import Foundation

struct HexPosition: Hashable, Equatable {
    let column: Int
    let row: Int
}

enum Direction: CaseIterable {
    case east
    case southEast
    case southWest
    case west
    case northWest
    case northEast

    var vector: (x: Int, y: Int) {
        switch self {
        case .northEast: return (x: 1, y: -1)
        case .east: return (x: 2, y: 0)
        case .southEast: return (x: 1, y: 1)
        case .southWest: return (x: -1, y: 1)
        case .west: return (x: -2, y: 0)
        case .northWest: return (x: -1, y: -1)
        }
    }
}


struct Hexagon {
    let position: HexPosition

    func getNeighborPosition(direction: Direction) -> HexPosition {
        position + direction.vector
    }

    func getAllNeighbors() -> [HexPosition] {
        Direction.allCases.map { dir in
            position+dir.vector
        }
    }
}

extension HexPosition {
    static func + (lhs: HexPosition, rhs: (x: Int, y: Int)) -> HexPosition {
        return HexPosition(column: lhs.column + rhs.x, row: lhs.row + rhs.y)
    }
}
