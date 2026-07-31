//
//  CoreGame.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 03.03.2026.
//
import Foundation

struct CoreGame {
    var positions: [HexPosition] {
        var allPosition: [HexPosition] = []
        for i in -4...4 {
            for j in -2...2 where (i + j) % 2 == 0 && !(abs(i) == 4 && abs(j) == 2) {
                allPosition.append(HexPosition(column: i, row: j))
            }
        }
        return allPosition
    }

    var hexagons: [Hexagon] {
        positions.map{ Hexagon(position: $0)}
    }

    var vertices: [VertexPosition] {
        let verticesForEachHex = hexagons.map{hex in getVertices(for: hex)}
        let allVertices = Array(NSOrderedSet(array: verticesForEachHex.flatMap(\.self))) as! [VertexPosition]
        return allVertices
    }

    var roads: [Road] {
        let roadsForEachVertex = vertices.map { vertex in
            getRoads(for: vertex) }
        let allRoads = Array(Set(roadsForEachVertex.flatMap(\.self)))
        return allRoads
    }
}

private extension CoreGame {
    func getRoads(for vertex: VertexPosition) -> [Road] {
        var result: [Road] = []
        for neighborVertex in vertex.allNeighbors {
            result.append(Road(roadPosition: [vertex, neighborVertex]))
        }
        return result
    }

    func getVertices(for hex: Hexagon) -> [VertexPosition] {
        let allNeighbors = hex.getAllNeighbors()
        let pairs = allNeighbors.indices.map { i in
            (allNeighbors[i], allNeighbors[(i+1)%allNeighbors.count])
        }
        var result = [VertexPosition]()
        for (first, second) in pairs {
            var vertexConnectionType: VertexNeighborsLayout
            if first.row == hex.position.row {
                if second.row < first.row {
                    if first.column > hex.position.column {
                        vertexConnectionType = VertexNeighborsLayout.yLayout(YNeighborsLayout(north: second, southEast: first, southWest: hex.position))
                    } else {
                        vertexConnectionType = VertexNeighborsLayout.yLayout(YNeighborsLayout(north: second, southEast: hex.position, southWest: first))
                    }
                } else {
                    if first.column > hex.position.column {
                        vertexConnectionType = VertexNeighborsLayout.hLayout(HNeighborsLayout(northWest: hex.position, northEast: first, south: second))
                    } else {
                        vertexConnectionType = VertexNeighborsLayout.hLayout(HNeighborsLayout(northWest: first, northEast: hex.position, south: second))
                    }
                }
            } else if first.row == second.row {
                if hex.position.row < first.row {
                    if first.column > second.column {
                        vertexConnectionType = VertexNeighborsLayout.yLayout(YNeighborsLayout(north: hex.position, southEast: first, southWest: second))
                    } else {
                        vertexConnectionType = VertexNeighborsLayout.yLayout(YNeighborsLayout(north: hex.position, southEast: second, southWest: first))
                    }
                } else {
                    if second.column > first.column {
                        vertexConnectionType = VertexNeighborsLayout.hLayout(HNeighborsLayout(northWest: first, northEast: second, south: hex.position))
                    } else {
                        vertexConnectionType = VertexNeighborsLayout.hLayout(HNeighborsLayout(northWest: second, northEast: first, south: hex.position))
                    }
                }
            } else {
                if first.row < second.row {
                    if second.column > hex.position.column {
                        vertexConnectionType = VertexNeighborsLayout.yLayout(YNeighborsLayout(north: first, southEast: second, southWest: hex.position))
                    } else {
                        vertexConnectionType = VertexNeighborsLayout.yLayout(YNeighborsLayout(north: first, southEast: hex.position, southWest: second))
                    }
                } else {
                    if second.column > hex.position.column {
                        vertexConnectionType = VertexNeighborsLayout.hLayout(HNeighborsLayout(northWest: hex.position, northEast: second, south: first))
                    } else {
                        vertexConnectionType = VertexNeighborsLayout.hLayout(HNeighborsLayout(northWest: second, northEast: hex.position, south: first))
                    }
                }
            }
            result.append(VertexPosition(vertexLayout: vertexConnectionType))
        }
        return result
    }
}

