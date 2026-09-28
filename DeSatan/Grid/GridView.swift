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
            width: rect.width,
            height: rect.height
        )
    }

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
                ForEach(gridViewModel.showedRoads, id: \.self) { road in
                    gridLayoutEngine.roadShape(for: road)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(.green)
                }
                ForEach(gridViewModel.possibleRoads, id: \.self) { road in
                    if gridViewModel.showPossibleRoads {
                        gridLayoutEngine.roadShape(for: road)
                            .stroke(lineWidth: 2)
                            .contentShape(gridLayoutEngine.roadShape(for: road).stroke(lineWidth: 6))
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                gridViewModel.placeRoad(at: road)
                                gridViewModel.showPossibleRoads.toggle()
                            }
                    }
                }

            }
        }
    }
}
