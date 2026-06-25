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
            width: rect.width,
            height: rect.height
        )
    }
    var body: some View {
        ZStack {
            ForEach(0..<gridLayoutEngine.hexShapes.count, id: \.self) { i in
                gridLayoutEngine.hexShapes[i]
            }
//            ForEach(gridLayoutEngine.allVertices, id: \.self) { vertex in
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: 8, height: 8)
//                    .position(vertex)
//            }

            Color.clear
                .contentShape(
                    Rectangle()
                        .size(width: rect.width,
                              height: rect.height
                             )
                )
                .onTapGesture { location in
//                    if let vertex = gridLayoutEngine.allVertices.first(where: {
//                        distance($0, location) < 10
//                    }) {
//                        print("Tapped vertex at: \(vertex)")
//                    }
//                    else if let position = isPoint(location, positionToCenter: centerToPosition, size: gridLayoutEngine.hexSize) {
//                        print("tapped hex with position: \(position)")
//                    }
//                    else {
//                        print("tapped somewhere else: \(location)")
//                    }
                }
        }
    }
    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
    }

    private func isPoint(_ point: CGPoint, positionToCenter: [(CGPoint, HexPosition)], size: CGFloat) -> HexPosition? {
        for (vertex, position) in positionToCenter {
            if distance(vertex, point) <= size {
                return position
            }
        }
        return nil
    }
    private func gridHeight(height: CGFloat, hexSize: CGFloat, spacing: Double, vertexSize: Double) -> CGFloat {
        height - (hexSize+spacing)*8 + 20
    }
}
