//
//  GridViewModel.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 25/06/2026.
//

import Foundation

@Observable
class GridViewModel {
    let coreGame: CoreGame
    let hexagons: [Hexagon]
    let roads: [Road]
    var possibleVertices: [VertexPosition] = []
    var showedVertices: [VertexPosition] = []
    var showPossibleVertices: Bool = false

    init(coreGame: CoreGame) {
        self.coreGame = coreGame
        self.hexagons = coreGame.hexagons
        self.roads = coreGame.roads
    }

    func refreshPossibleVertices() {
        if showedVertices.isEmpty {
            possibleVertices = coreGame.allVertices
        } else {
            // IT IS UGLY
            let fistStepNeighbours = Array(Set(showedVertices.flatMap{vertex in vertex.allNeighbors}))

            possibleVertices = Array(Set(fistStepNeighbours.flatMap{vertex in vertex.allNeighbors}))
        }
        showPossibleVertices.toggle()
    }

    func placeVertex(at position: VertexPosition) {
        guard possibleVertices.contains(position) else { return }
        showedVertices.append(position)
        possibleVertices.removeAll { $0 == position }
    }


    
}
