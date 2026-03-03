//
//  CoreGame.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 03.03.2026.
//

struct CoreGame {
    let hexPositions = Self.getHexPosition()

    private static func getHexPosition() -> [HexPosition] {
        var result: [HexPosition] = []
        for i in -4...4 {
            for j in -2...2 {
                if (i + j) % 2 == 0 && !(abs(i) == 4 && abs(j) == 2) {
                    result.append(HexPosition(column: i, row: j))
                }
            }
        }
        return result
    }
}
