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

struct YNeighborsLayout {
    let north: HexPosition
    let southEast: HexPosition
    let southWest: HexPosition
}

struct HNeighborsLayout {
    let northWest: HexPosition
    let northEast: HexPosition
    let south: HexPosition
}

enum VertexNeighborsLayout {
    case yLayout(YNeighborsLayout)
    case hLayout(HNeighborsLayout)
    var vertices: [HexPosition]  {
        switch self {
        case .yLayout(let yLayout):
            return [yLayout.north, yLayout.southEast, yLayout.southWest]
        case .hLayout(let hLayout):
            return [hLayout.northEast, hLayout.south, hLayout.northWest]
        }
    }
}

struct VertexPosition {
    enum DrawingNeighbor {
        case one(HexPosition)
        case two(HexPosition, HexPosition)
        case three(HexPosition, HexPosition, HexPosition)
    }
    let drawingHexNeighbor: DrawingNeighbor
    let vertexLayout: VertexNeighborsLayout


    var allNeighbors: [VertexPosition] {
        var neighbors: [VertexPosition] = []
        switch vertexLayout {
        case .yLayout(let yVertexDirection):
            for direction in YNeighborDirection.allCases {
                let vertexConnectionType = getYDirectionNeighbor(yVertexDirection, in: direction)
                guard let drawingNeighbors = drawableNeighbors(firstHex: vertexConnectionType.northEast, secondHex: vertexConnectionType.northWest, thirdHex: vertexConnectionType.south) else { continue }
                neighbors.append(VertexPosition(drawingHexNeighbor: drawingNeighbors, vertexLayout: VertexNeighborsLayout.hLayout(vertexConnectionType)))

            }
        case .hLayout(let hVertexDirection):
            for direction in HNeighborDirection.allCases {
                let vertexConnectionType = getHDirectionNeighbor(hVertexDirection, in: direction)
                guard let drawingNeighbors = drawableNeighbors(firstHex: vertexConnectionType.north, secondHex: vertexConnectionType.southEast, thirdHex: vertexConnectionType.southWest) else { continue }
                neighbors.append(VertexPosition(drawingHexNeighbor: drawingNeighbors, vertexLayout: VertexNeighborsLayout.yLayout(vertexConnectionType)))
            }
        }
        return neighbors
    }

    func getYDirectionNeighbor(_ vertex: YNeighborsLayout, in direction: YNeighborDirection) -> HNeighborsLayout {
        switch direction {
        case .northEast:
            let northEast = HexPosition(column: vertex.southWest.column + 3, row: vertex.southWest.row - 1)
            return HNeighborsLayout(northWest: vertex.north, northEast: northEast, south: vertex.southEast)
        case .northWest:
            let northWest = HexPosition(column: vertex.southEast.column - 3, row: vertex.southEast.row - 1)
            return HNeighborsLayout(northWest: northWest, northEast: vertex.north, south: vertex.southWest)
        case .south:
            let south = HexPosition(column: vertex.north.column, row: vertex.north.row + 2)
            return HNeighborsLayout(northWest: vertex.southWest, northEast: vertex.southEast, south: south)
        }
    }

    func getHDirectionNeighbor(_ vertex: HNeighborsLayout, in direction: HNeighborDirection) -> YNeighborsLayout {
        switch direction {
        case .north:
            let north = HexPosition(column: vertex.south.column, row: vertex.south.row - 2)
            return YNeighborsLayout(north: north, southEast: vertex.northEast, southWest: vertex.northWest)
        case .southEast:
            let southEast = HexPosition(column: vertex.northWest.column + 3, row: vertex.northWest.row + 1)
            return YNeighborsLayout(north: vertex.northEast, southEast: southEast, southWest: vertex.south)
        case .southWest:
            let southWest = HexPosition(column: vertex.northEast.column - 3, row: vertex.northEast.row + 1)
            return YNeighborsLayout(north: vertex.northWest, southEast: vertex.south, southWest: southWest)
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
        if lhs.vertexLayout.vertices == rhs.vertexLayout.vertices {
            return true
        } else {
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(vertexLayout.vertices)
    }
}
