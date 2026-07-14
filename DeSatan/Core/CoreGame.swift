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
        let allVertices = Set(verticesForEachHex.flatMap(\.self))
        return Array(allVertices)
    }

    func getHexPosition() -> [Hexagon] {
        var result: [Hexagon] = []
        for i in -4...4 {
            for j in -2...2 {
                if (i + j) % 2 == 0 && !(abs(i) == 4 && abs(j) == 2) {
                    let hexPosition = HexPosition(column: i, row: j)
                    let hex = Hexagon(position: hexPosition)
                    result.append(hex)
                }
            }
        }
        return result
    }

    private func getVertices(for hex: Hexagon) -> [VertexPosition] {
        let allNeighbors = hex.getAllNeighbors()
//        print("\nNeighbors: \(allNeighbors)\n")
        let pairs = allNeighbors.indices.map { i in
            (allNeighbors[i], allNeighbors[(i+1)%allNeighbors.count])
        }
        var result = [VertexPosition]()
//        print("\n pairs:")
        for (first, second) in pairs {
//            print("current: \(hex.position) First: \(first.column), \(first.row); Second: \(second.column), \(second.row)")
            if positions.contains(first) && positions.contains(second) {
                result.append(VertexPosition(drawingNeighbor: .three(hex.position, first, second), neighbors: [hex.position, first, second]))
            } else if positions.contains(first) {
                result.append(VertexPosition(drawingNeighbor: .two(hex.position, first), neighbors: [hex.position, first, second]))
            } else if positions.contains(second) {
                result.append(VertexPosition(drawingNeighbor: .two(hex.position, second), neighbors: [hex.position, first, second]))
            } else {
                result.append(VertexPosition(drawingNeighbor: .one(hex.position), neighbors: [hex.position, first, second]))
            }
        }
        return result
    }
}
