//
//  GridLayoutEngine.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 03.03.2026.
//

import Foundation

struct GridLayoutEngine {
    private enum Constans {
        static let numberOfSpaces = 10.0
        static let vertexRadius = 8.0
        static let maxNumberOfHexInARow = 5.0
        static let xCenterConstant: Double = sqrt(3)/2
        static let yCenterConstant: Double = 3.0/2
    }
    /// The fraction of each side length to round, from 0 (sharp corners) to 0.5 (maximum rounding).
    private let hexagons: [Hexagon]
    private let hexCornerRatio: CGFloat
    private let width: CGFloat
    private var drawingHexSize: CGFloat { hexSize + spacing }
    private let spacing: Double
    
    var hexSize: CGFloat {
        let realWidth = width - (Constans.numberOfSpaces*spacing) - Constans.vertexRadius
        return (realWidth/(Constans.maxNumberOfHexInARow*sqrt(3)))
    }

    var hexCenters: [CGPoint] {
        let hexPositions = hexagons.map(\.position)
        return hexPositions.map{ position in
            let x = Constans.xCenterConstant * Double(position.column)
            let y = Constans.yCenterConstant * Double(position.row)
            return CGPoint(x: drawingHexSize * x, y: drawingHexSize * y) + CGPoint(x: width/2, y: width/2)
        }
    }
    var allVertices: [CGPoint] {
        Array(
            Set(hexCenters.flatMap { center in getVerticesForHex(at: center)})
        )
    }

    var hexShapes: [HexagonShape] {
        hexCenters.map { center in
            HexagonShape(adjustment: hexCornerRatio, size: hexSize, center: center, vertices: getVerticesForHex(at: center))
        }
    }

    init(hexagon: [Hexagon], width: CGFloat, height: CGFloat, hexCornerRatio: CGFloat = 0.1, spacing: Double = 2) {
        self.hexagons = hexagon
        self.hexCornerRatio = hexCornerRatio
        self.spacing = spacing
        self.width = width
    }

    private func getVerticesForHex(at center: CGPoint) -> [CGPoint] {
        var result = [CGPoint]()
        for i in 0..<6 {
            result.append(CGPoint.hexagonVertex(for: center, with: hexSize, at: i))
        }
        return result
    }
}
