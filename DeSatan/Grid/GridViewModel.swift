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
    var possibleVertices: [VertexPosition] = []
    var showedVertices: [VertexPosition] = []
    var possibleRoads: [Road] = []
    var showedRoads: [Road] = []
    var showPossibleVertices: Bool = false
    var showPossibleRoads: Bool = false

    init(coreGame: CoreGame) {
        self.coreGame = coreGame
        self.hexagons = coreGame.hexagons
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

    func refreshPossibleRoads() {
        if showedRoads.isEmpty {
            possibleRoads = coreGame.allRoads
        } else {
            possibleRoads = Array(Set(showedRoads.flatMap { road in
                road.allNeighbors
            }))
        }
        showPossibleRoads.toggle()
    }

    func placeRoad(at position: Road) {
        guard possibleRoads.contains(position) else { return }
        showedRoads.append(position)
        possibleRoads.removeAll{$0 == position}
    }

    func removeAllRoads() {
        possibleRoads = []
        showedRoads = []
    }


    
}
