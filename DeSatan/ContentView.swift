//
//  ContentView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 14.02.2026.
//

import SwiftUI



struct GameVertex: Hashable {
    var neighborHexagons = [HexPosition?]()
}

struct HexagonGame {
    let position: HexPosition
    let neighbors: [HexPosition]
    let vertices: [CGPoint]
}

struct ContentView: View {
    let coreGameModel: CoreGame
    var body: some View {
        GeometryReader { geometry in
            GridView(rect: geometry.frame(in: .local), gridViewModel: GridViewModel(coreGame: coreGameModel))
        }
    }
    init() {
        coreGameModel = CoreGame()
        print(coreGameModel.vertices)
    }
}

#Preview {
    ContentView()
}
