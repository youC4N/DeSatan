//
//  ContentView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 14.02.2026.
//

import SwiftUI

enum Direction: CaseIterable {
    case east
    case west
    case northWest
    case northEast
    case southWest
    case southEast

    var vector: (x: Int, y: Int) {
        switch self {
        case .northEast: return (x: 1, y: -1)
        case .east: return (x: 2, y: 0)
        case .southEast: return (x: 1, y: 1)
        case .southWest: return (x: -1, y: 1)
        case .west: return (x: -2, y: 0)
        case .northWest: return (x: -1, y: -1)
        }
    }
}

struct HexPosition: Hashable {
    let column: Int
    let row: Int
}



struct ContentView: View {
    let coreGameModel = CoreGame()
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let rect = geometry.frame(in: .global)
                let gridLayoutEngine = GridLayoutEngine(
                    positions: coreGameModel.hexPositions,
                    width: rect.width,
                    height: rect.height,
                    spacing: 5
                )

                let vertexGeometry = VertexGeometry(
                    hexCenters: gridLayoutEngine.hexCenters,
                    hexSize: gridLayoutEngine.hexSize,
                    hexSpacing: gridLayoutEngine.spacing
                )

                let centerToPosition = Array(zip(gridLayoutEngine.hexCenters, coreGameModel.hexPositions))


                ForEach(gridLayoutEngine.hexCenters, id: \.self) { center in
                    let hexGeometry = HexagonGeometry(
                        size: gridLayoutEngine.hexSize,
                        center: center
                    )
                    HexagonShape(
                        adjustment: gridLayoutEngine.hexCornerRatio,
                        size: gridLayoutEngine.hexSize,
                        center: center,
                        vertices: hexGeometry.vertices
                    )
                }

                ForEach(vertexGeometry.allVertices, id: \.self) { vertex in
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .position(vertex)
                }

                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        if let vertex = vertexGeometry.allVertices.first(where: {
                            distance($0, location) < 15
                        }) {
                            print("Tapped vertex at: \(vertex)")
                        }
                        else if let position = isPoint(location, positionToCenter: centerToPosition, size: gridLayoutEngine.hexSize) {
                            print("tapped hex with position: \(position)")
                        }
                        else {
                            print("tapped somewhere else: \(location)")
                        }
                    }
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

}






#Preview {
    ContentView()
}
