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
                let gridLayoutEngine = GridLayoutEngine(positions: coreGameModel.hexPositions, width: rect.width, height: rect.height)
                let centerToPosition = Array(zip(gridLayoutEngine.hexCenters, coreGameModel.hexPositions).enumerated())
                ForEach(centerToPosition, id: \.0) { indexedElement in
                    let (index, (center, position)) = indexedElement
                    let hexGeometry = HexagonGeometry(size: gridLayoutEngine.hexSize, center: center)
                    HexagonShape(adjustment: gridLayoutEngine.hexCornerRatio, size: gridLayoutEngine.hexSize, center: center, vertices: hexGeometry.vertices)
                        .onTapGesture {
                            print(position)
                        }
                }
            }
        }
    }
}






#Preview {
    ContentView()
}
