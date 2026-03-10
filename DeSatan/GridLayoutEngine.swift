//
//  GridLayoutEngine.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 03.03.2026.
//

import Foundation

struct GridLayoutEngine {
    let positions: [HexPosition]
    let width: CGFloat
    let height: CGFloat
    /// The fraction of each side length to round, from 0 (sharp corners) to 0.5 (maximum rounding).
    let hexCornerRatio: CGFloat
    let spacing: Double

    let hexSize: CGFloat
    let hexCenters: [CGPoint]

    init(positions: [HexPosition], width: CGFloat, height: CGFloat, hexCornerRatio: CGFloat = 0.1, spacing: Double = 1) {
        self.positions = positions
        self.width = width
        self.height = height
        self.hexCornerRatio = hexCornerRatio
        self.spacing = spacing
        let hexSize = Self.getHexSize(for: width, with: spacing)
        self.hexSize = hexSize
        self.hexCenters = positions.map{ Self.getHexCenter(for: hexSize, at: $0, with: spacing) + CGPoint(x: width/2, y: height/2) }
    }
}


private extension GridLayoutEngine {
    static func getHexSize(for width: CGFloat, with spacing: Double) -> CGFloat { (width - 10*spacing)/(5*sqrt(3)) }

    static func getHexCenter(for size: CGFloat, at position: HexPosition, with spacing: Double) -> CGPoint {
        let x = sqrt(3)/2  * Double(position.column)
        let y = 3.0/2 * Double(position.row)

        return CGPoint(x: (size+spacing) * x, y: (size+spacing) * y)
    }

}
