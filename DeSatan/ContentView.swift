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
    @State var gridViewModel: GridViewModel

    init() {
        self._gridViewModel = State(initialValue: GridViewModel(coreGame: CoreGame()))
    }
    var body: some View {
        GeometryReader { geometry in
            VStack{
                GridView(rect: geometry.frame(in: .local), gridViewModel: gridViewModel)
                HStack{
                    Spacer()
                    Button {
                        print("Add house tapped")
                        gridViewModel.refreshPossibleVertices()
                    } label: {
                        Text("Add Vertex")
                    }
                    Spacer()
                    Button {
                        print("Add road tapped")
                    } label: {
                        Text("Add Road")
                    }
                    Spacer()

                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
