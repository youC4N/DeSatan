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

struct HexagonModel: Hashable {
    let position: HexPosition
    let center: CGPoint
    let size: CGFloat
    let vertices: [CGPoint]
    init(position: HexPosition, center: CGPoint, size: CGFloat = 40) {
        self.position = position
        self.center = center
        self.size = size
        self.vertices = [
            CGPoint.hexagonVertex(for: center, with: size, at: 0),
            CGPoint.hexagonVertex(for: center, with: size, at: 1),
            CGPoint.hexagonVertex(for: center, with: size, at: 2),
            CGPoint.hexagonVertex(for: center, with: size, at: 3),
            CGPoint.hexagonVertex(for: center, with: size, at: 4),
            CGPoint.hexagonVertex(for: center, with: size, at: 5)
        ]
    }
}

struct GridModel {
    let hexagonModels: [HexagonModel]
    let placeableVertices: [HexagonModel: Set<CGPoint>]

    init(hexagonModels: [HexagonModel]) {
        self.hexagonModels = hexagonModels
        self.placeableVertices = Self.getPlaceableVertices(from: hexagonModels)
    }

    private static func getPlaceableVertices(from hexagonModels: [HexagonModel]) -> [HexagonModel: Set<CGPoint>] {
        var result: [HexagonModel: Set<CGPoint>] = [:]
        for model in hexagonModels {
            let column = model.position.column
            let row = model.position.row

            for direction in Direction.allCases {

                let possibleHexPosition = HexPosition(column: column + direction.vector.x, row: row + direction.vector.y)
//                print("New column: \(column) + \(direction.vector.x)")
//                print("New row: \(row) + \(direction.vector.y)")
                //print("Direction: \(direction), CP: (\(column), \(row)), PP: (\(possibleHexPosition.column), \(possibleHexPosition.row)), result: \(hexagonModels.map(\.position).contains(possibleHexPosition))")
                if hexagonModels.map(\.position).contains(possibleHexPosition) {
                    switch direction{
                    case .northEast:
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 5))
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 0))
                    case .east:
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 0))
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 1))
                    case .southEast:
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 1))
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 2))
                    case .southWest:
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 2))
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 3))
                    case .west:
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 3))
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 4))
                    case .northWest:
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 4))
                        result[model, default: []].insert(CGPoint.hexagonVertex(for: model.center, with: model.size+1, at: 5))
                    }
                }
            }
        }
        return result
    }
}

struct HexPosition: Hashable {
    let column: Int
    let row: Int
}



struct ContentView: View {
    var body: some View {
        ZStack {
            HexagonGrid()
                .onTapGesture {
                    print("hello")
                }
//                if let vertices = gridModel.placeableVertices[model] {
//                    ForEach(Array(vertices), id: \.self) { vertex in
//                        Circle()
//                            .fill(Color.red)
//                            .frame(width: 8, height: 8)
//                            .position(vertex)
//                    }
//                }
        }
    }
}





#Preview {
    ContentView()
}
