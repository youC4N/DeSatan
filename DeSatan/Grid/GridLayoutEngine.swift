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
    private let vertices: [VertexPosition]
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
        var result: [CGPoint] = []
        for vertex in vertices {
            switch vertex.drawingNeighbor {
            case .three, .two, .one:
                let neighbors = Array(vertex.neighbors)

                let xFirstCenter = getHexCenter(for: neighbors[0]).x
                let yFirstCenter = getHexCenter(for: neighbors[0]).y

                let xSecondCenter = getHexCenter(for: neighbors[1]).x
                let ySecondCenter = getHexCenter(for: neighbors[1]).y

                let xThirdCenter = getHexCenter(for: neighbors[2]).x
                let yThirdCenter = getHexCenter(for: neighbors[2]).y

                /// x1^2 - x2^2 + y1^2 - y2^2
                let a = pow(xFirstCenter, 2) - pow(xSecondCenter, 2) + pow(yFirstCenter, 2) - pow(ySecondCenter, 2)
                /// x1^2 - x3^2 + y1^2-y3^2
                let b = pow(xFirstCenter, 2) - pow(xThirdCenter, 2) + pow(yFirstCenter, 2) - pow(yThirdCenter, 2)
                /// numerator
                let c = ((a*(yFirstCenter-yThirdCenter)) - (b*(yFirstCenter - ySecondCenter)))
                let d = (xFirstCenter - xSecondCenter)*(yFirstCenter - yThirdCenter)
                let e = (xFirstCenter - xThirdCenter)*(yFirstCenter - ySecondCenter)
                let xVertex =  c/(2*(d - e))

                let a1 = pow(xFirstCenter, 2) - pow(xThirdCenter, 2) + pow(yFirstCenter, 2) - pow(yThirdCenter, 2)
                let b1 = pow(xFirstCenter, 2) - pow(xSecondCenter, 2) + pow(yFirstCenter, 2) - pow(ySecondCenter, 2)
                let c1 = ((xFirstCenter - xSecondCenter)*a1) - ((xFirstCenter - xThirdCenter)*(b1))
                let d1 = (xFirstCenter - xSecondCenter)*(yFirstCenter - yThirdCenter)
                let e1 = (xFirstCenter - xThirdCenter)*(yFirstCenter - ySecondCenter)
                let yVertex = (c1)/(2*(d1 - e1))
                result.append(CGPoint(x: xVertex, y: yVertex))

            default:
                print()
            }
        }
        print(result.count)
        return result
    }

    var hexShapes: [HexagonShape] {
        hexCenters.map { center in
            HexagonShape(adjustment: hexCornerRatio, size: hexSize, center: center, vertices: getVerticesForHex(at: center))
        }
    }

    init(hexagon: [Hexagon], vertices: [VertexPosition], width: CGFloat, height: CGFloat, hexCornerRatio: CGFloat = 0.1, spacing: Double = 2) {
        self.hexagons = hexagon
        self.vertices = vertices
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

    private func getHexCenter(for position: HexPosition) -> CGPoint {
        let x = Constans.xCenterConstant * Double(position.column)
        let y = Constans.yCenterConstant * Double(position.row)
        return CGPoint(x: drawingHexSize * x, y: drawingHexSize * y) + CGPoint(x: width/2, y: width/2)

    }
}
