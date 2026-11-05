//
//  Result+Extension.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 05/11/2026.
//

import Foundation

extension Result where Failure == any Error {
    init(catching block: () async throws -> Success) async {
        do {
            self = .success(try await block())
        } catch {
            self = .failure(error)
        }
    }
}
