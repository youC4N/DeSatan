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
    let positions = getHexPosition()
    var body: some View {
        ZStack {
            ForEach(positions, id: \.self) { position in
                Hex(position: position, adjustment: 0.1)
                    .onTapGesture {
                        print(position)
                    }
            }
        }
    }
}


func getHexPosition() -> [HexPosition] {
    var result: [HexPosition] = []
    for i in -4...4 {
        for j in -2...2 {
            if (i + j) % 2 == 0 && !(abs(i) == 4 && abs(j) == 2) {
                result.append(HexPosition(column: i, row: j))
            }
        }
    }
    return result
}



#Preview {
    ContentView()
}
