//
//  RoadShape.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 31/07/2026.
//

import SwiftUI

struct RoadShape: Shape {
    let vertices: [CGPoint]
    nonisolated func path(in rect: CGRect) -> Path {
        let firstVertex = vertices[0]
        let secondVertex = vertices[1]
        var path = Path()
        path.move(to: firstVertex)
        path.addLine(to: secondVertex)
        return path
    }
}
