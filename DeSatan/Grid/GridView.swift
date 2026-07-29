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

    init(rect: CGRect, gridViewModel: GridViewModel) {
        self.rect = rect
        self.gridViewModel = gridViewModel
        self.gridLayoutEngine = GridLayoutEngine(
            hexagon: gridViewModel.hexagons,
            vertices: gridViewModel.vertices,
            width: rect.width,
            height: rect.height
        )
    }
    var body: some View {
        ZStack(alignment: .center, content: {
            ForEach(0..<gridLayoutEngine.hexShapes.count, id: \.self) { i in
                gridLayoutEngine.hexShapes[i]
                    .contentShape(gridLayoutEngine.hexShapes[i])
                    .onTapGesture {
                        print(gridViewModel.hexagons[i])
                    }
            }
            ForEach(gridLayoutEngine.allVertices, id: \.self) { vertex in
                Button {
                    print(vertex.x, vertex.y)
                } label: {
                    Circle()
                        .fill(.red)
                        .frame(width: 8)
                }
                .frame(width: 35, height: 35)
                .contentShape(Circle())
                .position(vertex)
            }
        })
    }
}
