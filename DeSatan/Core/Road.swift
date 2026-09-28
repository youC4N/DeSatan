//
//  Road.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 31/07/2026.
//

import Foundation

enum RoadConnectionDirection {
    case southEast
    case south
    case southWest
}

struct Road: Hashable {
    let roadPosition: [VertexPosition]

    private var connectionDirection: RoadConnectionDirection? {
        let upperVertex = roadPosition[0]
        let lowerVertex = roadPosition[1]

        switch (upperVertex.vertexLayout, lowerVertex.vertexLayout) {
        case (.yLayout, .hLayout):
            return .south
        case (.hLayout(let hLayout), .yLayout(let yLayout)):
            if hLayout.south == yLayout.southEast {
                return .southWest
            } else {
                return .southEast
            }
        default: return nil
        }
    }

    var allNeighbors: [Road] {
        var neighbors = [Road]()

        let upperVertex = roadPosition[0]
        let lowerVertex = roadPosition[1]

        switch upperVertex.vertexLayout {
        case .hLayout(let hLayout):
            if let connectionDirection {
                let northYLayout = upperVertex.getHDirectionNeighbor(hLayout, in: .north)
                let northVertex = VertexPosition(vertexLayout: .yLayout(northYLayout))
                let northRoad = Road(roadPosition: [northVertex, upperVertex])
                neighbors.append(northRoad)
                switch connectionDirection {
                case .southEast:
                    let southWestYLayout = upperVertex.getHDirectionNeighbor(hLayout, in: .southWest)
                    let southWestVertex = VertexPosition(vertexLayout: .yLayout(southWestYLayout))
                    let southWestRoad = Road(roadPosition: [upperVertex, southWestVertex])
                    neighbors.append(southWestRoad)
                case .southWest:
                    let southEastYLayout = upperVertex.getHDirectionNeighbor(hLayout, in: .southEast)
                    let southEastVertex = VertexPosition(vertexLayout: .yLayout(southEastYLayout))
                    let southEastRoad = Road(roadPosition: [upperVertex, southEastVertex])
                    neighbors.append(southEastRoad)
                case .south: break
                }
            }
        case .yLayout(let yLayout):
            let northWestHLayout = upperVertex.getYDirectionNeighbor(yLayout, in: .northWest)
            let northWestVertex = VertexPosition(vertexLayout: .hLayout(northWestHLayout))
            let northEastHLayout = upperVertex.getYDirectionNeighbor(yLayout, in: .northEast)
            let northEastVertex = VertexPosition(vertexLayout: .hLayout(northEastHLayout))
            let northWestRoad = Road(roadPosition: [northWestVertex, upperVertex])
            let northEastRoad = Road(roadPosition: [northEastVertex, upperVertex])
            neighbors += [northWestRoad, northEastRoad]
        }

        switch lowerVertex.vertexLayout {
        case .hLayout(let hLayout):
            let southEastYLayout = lowerVertex.getHDirectionNeighbor(hLayout, in: .southEast)
            let southEastVertex = VertexPosition(vertexLayout: .yLayout(southEastYLayout))
            let southEastRoad = Road(roadPosition: [lowerVertex, southEastVertex])
            let southWestYLayout = lowerVertex.getHDirectionNeighbor(hLayout, in: .southWest)
            let southWestVertex = VertexPosition(vertexLayout: .yLayout(southWestYLayout))
            let southWestRoad = Road(roadPosition: [lowerVertex, southWestVertex])
            neighbors += [southEastRoad, southWestRoad]
        case .yLayout(let yLayout):
            let southHLayout = lowerVertex.getYDirectionNeighbor(yLayout, in: .south)
            let southVertex = VertexPosition(vertexLayout: .hLayout(southHLayout))
            let southRoad = Road(roadPosition: [lowerVertex, southVertex])
            neighbors.append(southRoad)
            if let connectionDirection {
                switch connectionDirection {
                case .southEast:
                    let northEastHLayout = lowerVertex.getYDirectionNeighbor(yLayout, in: .northEast)
                    let northEastVertex = VertexPosition(vertexLayout: .hLayout(northEastHLayout))
                    let northEastRoad = Road(roadPosition: [northEastVertex, lowerVertex])
                    neighbors.append(northEastRoad)
                case .southWest:
                    let northWestHLayout = lowerVertex.getYDirectionNeighbor(yLayout, in: .northWest)
                    let northWestVertex = VertexPosition(vertexLayout: .hLayout(northWestHLayout))
                    let northWestRoad = Road(roadPosition: [northWestVertex, lowerVertex])
                    neighbors.append(northWestRoad)
                default: break
                }
            }

        }

        return neighbors
    }
}
