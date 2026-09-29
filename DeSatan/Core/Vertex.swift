//
//  Vertex.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 25/06/2026.
//

import Foundation
import Algorithms

enum NeighborDirection {
    case yNeighbor(YNeighborDirection)
    case hNeighbor(HNeighborDirection)
}
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
}

struct VertexPosition {
    let vertexLayout: VertexNeighborsLayout

    var vertices: [HexPosition] {
        switch vertexLayout {
        case .yLayout(let yLayout):
            return [yLayout.north, yLayout.southEast, yLayout.southWest]
        case .hLayout(let hLayout):
            return [hLayout.northEast, hLayout.south, hLayout.northWest]
        }
    }

    var onTheField: Bool {
        if vertices.filter({ $0.isDrawable() }).isEmpty {
            return false
        } else {
            return true
        }
    }

    var allNeighbors: [VertexPosition] {
        var neighbors: [VertexPosition] = []
        switch vertexLayout {
        case .yLayout(let yVertexDirection):
            for direction in YNeighborDirection.allCases {
                let vertexConnectionType = getYDirectionNeighbor(yVertexDirection, in: direction)
                let vertexLayout = VertexNeighborsLayout.hLayout(vertexConnectionType)
                let vertex = VertexPosition(vertexLayout: vertexLayout)
                if vertex.onTheField {
                    neighbors.append(vertex)
                }
            }
        case .hLayout(let hVertexDirection):
            for direction in HNeighborDirection.allCases {
                let vertexConnectionType = getHDirectionNeighbor(hVertexDirection, in: direction)
                let vertexLayout = VertexNeighborsLayout.yLayout(vertexConnectionType)
                let vertex = VertexPosition(vertexLayout: vertexLayout)
                if vertex.onTheField {
                    neighbors.append(vertex)
                }
            }
        }
        return neighbors
    }

    func connectionDirection(_ vertex: VertexPosition) -> NeighborDirection? {
        switch vertexLayout {
        case .yLayout(let yNeighborsLayout):
            for direction in YNeighborDirection.allCases {
                let neighborHLayout = getYDirectionNeighbor(yNeighborsLayout, in: direction)
                let neighborVertex = VertexPosition(vertexLayout: .hLayout(neighborHLayout))
                if neighborVertex == vertex && vertex.onTheField {
                    return .yNeighbor(direction)
                }
            }
        case .hLayout(let hNeighborsLayout):
            for direction in HNeighborDirection.allCases {
                let neighborYLayout = getHDirectionNeighbor(hNeighborsLayout, in: direction)
                let neighborVertex = VertexPosition(vertexLayout: .yLayout(neighborYLayout))
                if neighborVertex == vertex && vertex.onTheField {
                    return .hNeighbor(direction)
                }
            }
        }
        return nil
    }
}

extension VertexPosition: Hashable {
    static func == (lhs: VertexPosition, rhs: VertexPosition) -> Bool {
        if lhs.vertices == rhs.vertices {
            return true
        } else {
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(vertices)
    }
}

extension VertexPosition {
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
}
