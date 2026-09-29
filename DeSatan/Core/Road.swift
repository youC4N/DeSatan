//
//  Road.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 31/07/2026.
//

import Foundation


struct Road: Hashable {
    let roadPosition: Set<VertexPosition>

    var allNeighbors: [Road] {
        let roadVertices = Array(roadPosition)
        let firstVertex = roadVertices[0]
        let secondVertex = roadVertices[1]
        guard let firstConnectionDirection = firstVertex.connectionDirection(secondVertex),
              let secondConnectionDirection = secondVertex.connectionDirection(firstVertex) else { fatalError() }
        let firstVertexRoads = foo(direction: firstConnectionDirection, vertex: firstVertex)
        let secondVertexRoads = foo(direction: secondConnectionDirection, vertex: secondVertex)
        return firstVertexRoads + secondVertexRoads
    }

    func foo(direction: NeighborDirection, vertex: VertexPosition) -> [Road] {
        var result = [Road]()
        let layout = vertex.vertexLayout
        switch layout {
        case .hLayout(let hLayout):
            switch direction {
            case .hNeighbor(let neighborDirection):
                switch neighborDirection {
                case .north:
                    let southEastYLayout = vertex.getHDirectionNeighbor(hLayout, in: .southEast)
                    let southEastVertex = VertexPosition(vertexLayout: .yLayout(southEastYLayout))
                    if southEastVertex.onTheField {
                        let road = Road(roadPosition: [vertex, southEastVertex])
                        result.append(road)
                    }
                    let southWestYLayout = vertex.getHDirectionNeighbor(hLayout, in: .southWest)
                    let southWestVertex = VertexPosition(vertexLayout: .yLayout(southWestYLayout))
                    if southWestVertex.onTheField {
                        let road = Road(roadPosition: [vertex, southWestVertex])
                        result.append(road)
                    }
                case .southEast:
                    let northYLayout = vertex.getHDirectionNeighbor(hLayout, in: .north)
                    let northVertex = VertexPosition(vertexLayout: .yLayout(northYLayout))
                    if northVertex.onTheField {
                        let road = Road(roadPosition: [vertex, northVertex])
                        result.append(road)
                    }
                    let southWestYLayout = vertex.getHDirectionNeighbor(hLayout, in: .southWest)
                    let southWestVertex = VertexPosition(vertexLayout: .yLayout(southWestYLayout))
                    if southWestVertex.onTheField {
                        let road = Road(roadPosition: [vertex, southWestVertex])
                        result.append(road)
                    }
                case .southWest:
                    let northYLayout = vertex.getHDirectionNeighbor(hLayout, in: .north)
                    let northVertex = VertexPosition(vertexLayout: .yLayout(northYLayout))
                    if northVertex.onTheField {
                        let road = Road(roadPosition: [vertex, northVertex])
                        result.append(road)
                    }
                    let southEastYLayout = vertex.getHDirectionNeighbor(hLayout, in: .southEast)
                    let southEastVertex = VertexPosition(vertexLayout: .yLayout(southEastYLayout))
                    if southEastVertex.onTheField {
                        let road = Road(roadPosition: [vertex, southEastVertex])
                        result.append(road)
                    }
                }
            case .yNeighbor: break
            }
        case .yLayout(let yLayout):
            switch direction {
            case .yNeighbor(let neighborDirection):
                switch neighborDirection {
                case .northEast:
                    let northWestHLayout = vertex.getYDirectionNeighbor(yLayout, in: .northWest)
                    let northWestVertex = VertexPosition(vertexLayout: .hLayout(northWestHLayout))
                    if northWestVertex.onTheField {
                        let road = Road(roadPosition: [vertex, northWestVertex])
                        result.append(road)
                    }
                    let southHLayout = vertex.getYDirectionNeighbor(yLayout, in: .south)
                    let southVertex = VertexPosition(vertexLayout: .hLayout(southHLayout))
                    if southVertex.onTheField {
                        let road = Road(roadPosition: [vertex, southVertex])
                        result.append(road)
                    }
                case .northWest:
                    let northEastHLayout = vertex.getYDirectionNeighbor(yLayout, in: .northEast)
                    let northEastVertex = VertexPosition(vertexLayout: .hLayout(northEastHLayout))
                    if northEastVertex.onTheField {
                        let road = Road(roadPosition: [vertex, northEastVertex])
                        result.append(road)
                    }
                    let southHLayout = vertex.getYDirectionNeighbor(yLayout, in: .south)
                    let southVertex = VertexPosition(vertexLayout: .hLayout(southHLayout))
                    if southVertex.onTheField {
                        let road = Road(roadPosition: [vertex, southVertex])
                        result.append(road)
                    }
                case .south:
                    let northEastHLayout = vertex.getYDirectionNeighbor(yLayout, in: .northEast)
                    let northEastVertex = VertexPosition(vertexLayout: .hLayout(northEastHLayout))
                    if northEastVertex.onTheField {
                        let road = Road(roadPosition: [vertex, northEastVertex])
                        result.append(road)
                    }
                }
                let northWestHLayout = vertex.getYDirectionNeighbor(yLayout, in: .northWest)
                let northWestVertex = VertexPosition(vertexLayout: .hLayout(northWestHLayout))
                if northWestVertex.onTheField {
                    let road = Road(roadPosition: [vertex, northWestVertex])
                    result.append(road)
                }
            case .hNeighbor: break
            }
        }
        return result
    }
}
