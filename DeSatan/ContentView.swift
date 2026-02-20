//
//  ContentView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 14.02.2026.
//

import SwiftUI

enum MockHexColor: ShapeStyle, CaseIterable{
    case forest
    case pasture
    case field
    case hills
    case mountains
    case desert

    var color: Color {
        switch self {
        case .forest:
            return Color(red: 0.13, green: 0.55, blue: 0.13) // forest green
        case .pasture:
            return Color(red: 0.56, green: 0.74, blue: 0.56) // soft green
        case .field:
            return Color(red: 0.42, green: 0.56, blue: 0.14) // olive
        case .hills:
            return Color(red: 0.58, green: 0.44, blue: 0.33) // brownish
        case .mountains:
            return Color(red: 0.50, green: 0.50, blue: 0.50) // gray
        case .desert:
            return Color(red: 0.93, green: 0.79, blue: 0.69) // sand
        }
    }

    static var random: MockHexColor {
        return allCases.randomElement()!
    }

    func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        color.resolve(in: environment)
    }
}

struct HexPosition {
    let column: Int
    let row: Int
}

func getHexCenter(for size: Double, at position: HexPosition) -> CGPoint {
    let x = sqrt(3)/2  * Double(position.column)
    let y = 3.0/2 * Double(position.row)

    return CGPoint(x: (size+1) * x, y: (size+1) * y)
}

func gridCenters() -> [HexPosition] {
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

struct ContentView: View {
    var body: some View {
        let hexCenters = gridCenters().map { hexPosition in
            getHexCenter(for: 40, at: hexPosition)
        }
        
        ZStack {
            ForEach(hexCenters, id: \.self) { center in
                Hex(size: 40, adjustment: 0, hexCenter: center)
                    .foregroundStyle(MockHexColor.random)
            }
        }
        .offset(x: 200, y: 200)
    }
}

#Preview {
    ContentView()
}
