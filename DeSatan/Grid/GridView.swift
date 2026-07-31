//
//  GridView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 17.03.2026.
//

import SwiftUI

struct GridView: View {
    let rect: CGRect
    let gridLayoutEngine: GridLayoutEngine
    let gridViewModel: GridViewModel
    let vertices: [VertexPosition]

    @State private var currentVertexIndex = 0   

    init(rect: CGRect, gridViewModel: GridViewModel) {
        self.rect = rect
        self.gridViewModel = gridViewModel
        self.gridLayoutEngine = GridLayoutEngine(
            hexagon: gridViewModel.hexagons,
            vertices: gridViewModel.vertices,
            width: rect.width,
            height: rect.height
        )
        self.vertices = gridLayoutEngine.vertices
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

                // All vertices (commented out)
                // ForEach(gridLayoutEngine.allVertices, id: \.self) { vertex in
                //     Button {
                //         print(vertex.x, vertex.y)
                //     } label: {
                //         Circle()
                //             .fill(.red)
                //             .frame(width: 8)
                //     }
                //     .frame(width: 35, height: 35)
                //     .contentShape(Circle())
                //     .position(vertex)
                // }

                // Neighbors of the current vertex
                if !vertices.isEmpty {
                    let currentVertex = vertices[currentVertexIndex]
                    ForEach(0..<currentVertex.allNeighbors.count, id: \.self) { i in
                        Button {
                            // print(currentVertex)
                        } label: {
                            Circle()
                                .fill(.green)
                                .frame(width: 8)
                        }
                        .frame(width: 35, height: 35)
                        .contentShape(Circle())
                        .position(gridLayoutEngine.vertexCoordinates(for: currentVertex.allNeighbors[i]))
                    }

                    // Current vertex (red)
                    Button {
                        // action
                    } label: {
                        Circle()
                            .fill(.red)
                            .frame(width: 8)
                    }
                    .frame(width: 35, height: 35)
                    .contentShape(Circle())
                    .position(gridLayoutEngine.vertexCoordinates(for: currentVertex))
                }
            }

            // NEXT button
            Button("NEXT") {
                if !vertices.isEmpty {
                    currentVertexIndex = (currentVertexIndex + 1) % vertices.count
                }
            }
            .padding()
        }
    }
}
