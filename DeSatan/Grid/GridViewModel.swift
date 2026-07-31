//
//  GridViewModel.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 25/06/2026.
//

import Foundation

@Observable
class GridViewModel {
    let hexagons: [Hexagon]
    let vertices: [VertexPosition]
    let roads: [Road]

    init(coreGame: CoreGame) {
        self.hexagons = coreGame.hexagons
        self.vertices = coreGame.vertices
        self.roads = coreGame.roads
    }
}
