//
//  Vertex.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 25/06/2026.
//

import Foundation
import Algorithms

enum YNeighborDirection: CaseIterable {
    case northWest
    case northEast
    case south
}
enum HNeighborDirection: CaseIterable {
    case north
    case southEast
    case southWest
}

struct YVertexDirection {
    let north: HexPosition
    let southEast: HexPosition
    let southWest: HexPosition
}

struct HVertexDirection {
    let northWest: HexPosition
    let northEast: HexPosition
    let south: HexPosition
}

enum VertexDirection {
    case yDirection(YVertexDirection)
    case hDirection(HVertexDirection)
}

struct VertexPosition {
    enum DrawingNeighbor {
        case one(HexPosition)
        case two(HexPosition, HexPosition)
        case three(HexPosition, HexPosition, HexPosition)
    }
    let drawingHexNeighbor: DrawingNeighbor
    let hexNeighbors: Set<HexPosition>
    let vertexConnectionType: VertexDirection


    var allNeighbors: [VertexPosition] {
        var neighbors: [VertexPosition] = []
        switch vertexConnectionType {
        case .yDirection(let yVertexDirection):
            for direction in YNeighborDirection.allCases {
                let vertexConnectionType = getYDirectionNeighbor(yVertexDirection, in: direction)
                guard let drawingNeighbors = drawableNeighbors(firstHex: vertexConnectionType.northEast, secondHex: vertexConnectionType.northWest, thirdHex: vertexConnectionType.south) else { continue }
                neighbors.append(VertexPosition(drawingHexNeighbor: drawingNeighbors, hexNeighbors: [vertexConnectionType.northEast, vertexConnectionType.northWest, vertexConnectionType.south], vertexConnectionType: VertexDirection.hDirection(vertexConnectionType)))

            }
        case .hDirection(let hVertexDirection):
            for direction in HNeighborDirection.allCases {
                let vertexConnectionType = getHDirectionNeighbor(hVertexDirection, in: direction)
                guard let drawingNeighbors = drawableNeighbors(firstHex: vertexConnectionType.north, secondHex: vertexConnectionType.southEast, thirdHex: vertexConnectionType.southWest) else { continue }
                neighbors.append(VertexPosition(drawingHexNeighbor: drawingNeighbors, hexNeighbors: [vertexConnectionType.north, vertexConnectionType.southEast, vertexConnectionType.southWest], vertexConnectionType: VertexDirection.yDirection(vertexConnectionType)))
            }
        }
        return neighbors
    }

    func getYDirectionNeighbor(_ vertex: YVertexDirection, in direction: YNeighborDirection) -> HVertexDirection {
        switch direction {
        case .northEast:
            let northEast = HexPosition(column: vertex.southWest.column + 3, row: vertex.southWest.row - 1)
            return HVertexDirection(northWest: vertex.north, northEast: northEast, south: vertex.southEast)
        case .northWest:
            let northWest = HexPosition(column: vertex.southEast.column - 3, row: vertex.southEast.row - 1)
            return HVertexDirection(northWest: northWest, northEast: vertex.north, south: vertex.southWest)
        case .south:
            let south = HexPosition(column: vertex.north.column, row: vertex.north.row + 2)
            return HVertexDirection(northWest: vertex.southWest, northEast: vertex.southEast, south: south)
        }
    }

    func getHDirectionNeighbor(_ vertex: HVertexDirection, in direction: HNeighborDirection) -> YVertexDirection {
        switch direction {
        case .north:
            let north = HexPosition(column: vertex.south.column, row: vertex.south.row - 2)
            return YVertexDirection(north: north, southEast: vertex.northEast, southWest: vertex.northWest)
        case .southEast:
            let southEast = HexPosition(column: vertex.northWest.column + 3, row: vertex.northWest.row + 1)
            return YVertexDirection(north: vertex.northEast, southEast: southEast, southWest: vertex.south)
        case .southWest:
            let southWest = HexPosition(column: vertex.northEast.column - 3, row: vertex.northEast.row + 1)
            return YVertexDirection(north: vertex.northWest, southEast: vertex.south, southWest: southWest)
        }
    }

    func drawableNeighbors(firstHex: HexPosition, secondHex: HexPosition, thirdHex: HexPosition) -> DrawingNeighbor? {
        switch (firstHex.isDrawable(), secondHex.isDrawable(), thirdHex.isDrawable()) {
        case (true, true, true):
            return DrawingNeighbor.three(firstHex, secondHex, thirdHex)
        case (true, true, false):
            return DrawingNeighbor.two(firstHex, secondHex)
        case (true, false, false):
            return DrawingNeighbor.one(firstHex)
        case (false, false, false):
            return nil
        case (false, true, true):
            return DrawingNeighbor.two(secondHex, thirdHex)
        case (true, false, true):
            return DrawingNeighbor.two(firstHex, thirdHex)
        case (false, true, false):
            return DrawingNeighbor.one(secondHex)
        case (false, false, true):
            return DrawingNeighbor.one(thirdHex)
        }
    }

}

extension VertexPosition: Hashable {
    static func == (lhs: VertexPosition, rhs: VertexPosition) -> Bool {
        if lhs.hexNeighbors == rhs.hexNeighbors {
            return true
        } else {
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hexNeighbors)
    }
}
