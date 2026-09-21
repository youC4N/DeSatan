//
//  GridView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 17.03.2026.
//

import SwiftUI

struct GridView: View {
    enum Constans {
        static let roadWidth: CGFloat = 4
    }
    let rect: CGRect
    let gridViewModel: GridViewModel
    var vertices: [VertexPosition] { gridViewModel.showedVertices }
    var gridLayoutEngine: GridLayoutEngine {
        GridLayoutEngine(
            hexagon: gridViewModel.hexagons,
            vertices: gridViewModel.showedVertices,
            roads: gridViewModel.roads,
            width: rect.width,
            height: rect.height
        )
    }

    @State private var currentVertexIndex = 0   

    init(rect: CGRect, gridViewModel: GridViewModel) {
        self.rect = rect
        self.gridViewModel = gridViewModel
    }

    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                // Hexagons
                ForEach(0..<gridLayoutEngine.hexShapes.count, id: \.self) { i in
                    gridLayoutEngine.hexShapes[i]
                        .contentShape(gridLayoutEngine.hexShapes[i])
                        .onTapGesture {
                            // print(gridViewModel.hexagons[i])
                        }
                }
                ForEach(0..<gridLayoutEngine.allRoads.count, id: \.self) {i in
                    gridLayoutEngine.allRoads[i]
                        .stroke(Color.white, lineWidth: Constans.roadWidth)
                }
                 ForEach(gridViewModel.possibleVertices, id: \.self) { vertex in
                     Button {
                         gridViewModel.placeVertex(at: vertex)
                         gridViewModel.showPossibleVertices.toggle()
                     } label: {
                         if gridViewModel.showPossibleVertices {
                             Circle()
                                 .fill(.red)
                                 .frame(width: 8)
                         }
                     }
                     .frame(width: 35, height: 35)
                     .contentShape(Circle())
                     .position(gridLayoutEngine.vertexCoordinates(for: vertex))
                 }
                ForEach(gridViewModel.showedVertices, id: \.self) { vertex in
                    Circle()
                        .fill(.blue)
                        .frame(width: 8)
                        .frame(width: 35, height: 35)
                        .contentShape(Circle())
                        .position(gridLayoutEngine.vertexCoordinates(for: vertex))
                }


//                // Neighbors of the current vertex
//                if !vertices.isEmpty {
//                    let currentVertex = vertices[currentVertexIndex]
//                    ForEach(0..<currentVertex.allNeighbors.count, id: \.self) { i in
//                        Button {
//                            // print(currentVertex)
//                        } label: {
//                            Circle()
//                                .fill(.green)
//                                .frame(width: 8)
//                        }
//                        .frame(width: 35, height: 35)
//                        .contentShape(Circle())
//                        .position(gridLayoutEngine.vertexCoordinates(for: currentVertex.allNeighbors[i]))
//                    }
//
//                    // Current vertex (red)
//                    Button {
//                        // action
//                    } label: {
//                        Circle()
//                            .fill(.red)
//                            .frame(width: 8)
//                    }
//                    .frame(width: 35, height: 35)
//                    .contentShape(Circle())
//                    .position(gridLayoutEngine.vertexCoordinates(for: currentVertex))
//                }
            }

//            // NEXT button
//            Button("NEXT") {
//                if !vertices.isEmpty {
//                    currentVertexIndex = (currentVertexIndex + 1) % vertices.count
//                }
//            }
//            .padding()
        }
    }

    func getVertexPostion(for coordinates: CGPoint) -> VertexPosition? {
        // WORKITEM: it is not correct convertation to Int
        let column = (coordinates.x * 2) / sqrt(3)
        let row = (coordinates.y * 2) / 3
        let hexPosition = HexPosition(column: Int(column), row: Int(row))
        let hex = Hexagon(position: hexPosition)
        let hexagonCenter = gridLayoutEngine.getHexCenter(for: hexPosition)

        let hexVertices = gridLayoutEngine.getVerticesForHex(at: hexagonCenter)

        let distanceToEveryVertex = hexVertices.map{vertex in CGPoint.distance(vertex, coordinates)}
        let smallestDistance = distanceToEveryVertex.min()!
        let indexOfClosestVertex = distanceToEveryVertex.firstIndex(of: smallestDistance)!
        let realVertexCoordinate = hexVertices[indexOfClosestVertex]

        return switch indexOfClosestVertex {
        case 0:
            VertexPosition(vertexLayout: VertexNeighborsLayout.hLayout(HNeighborsLayout(northWest: hexPosition, northEast: hex.getNeighborPosition(direction: .east), south: hex.getNeighborPosition(direction: .southEast))))
        case 1: VertexPosition(vertexLayout: VertexNeighborsLayout.yLayout(YNeighborsLayout(north: hexPosition, southEast: hex.getNeighborPosition(direction: .southEast), southWest: hex.getNeighborPosition(direction: .southWest))))
        case 2: VertexPosition(vertexLayout: VertexNeighborsLayout.hLayout(HNeighborsLayout(northWest: hex.getNeighborPosition(direction: .west), northEast: hexPosition, south: hex.getNeighborPosition(direction: .southWest))))
        case 3: VertexPosition(vertexLayout: VertexNeighborsLayout.yLayout(YNeighborsLayout(north: hex.getNeighborPosition(direction: .northWest), southEast: hexPosition, southWest: hex.getNeighborPosition(direction: .west))))
        case 4: VertexPosition(vertexLayout: VertexNeighborsLayout.hLayout(HNeighborsLayout(northWest: hex.getNeighborPosition(direction: .northWest), northEast: hex.getNeighborPosition(direction: .northEast), south: hexPosition)))
        case 5: VertexPosition(vertexLayout: VertexNeighborsLayout.yLayout(YNeighborsLayout(north: hex.getNeighborPosition(direction: .northEast), southEast: hex.getNeighborPosition(direction: .east), southWest: hexPosition)))
        default: nil
        }

    }
}
