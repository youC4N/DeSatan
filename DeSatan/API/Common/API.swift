//
//  API.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 25/10/2026.
//

import Foundation

import Foundation
import OSLog

struct API {
    static let local = API(base: URL(string: "http://127.0.0.1:8080")!)
    static let logger = Logger(subsystem: "com.github.youC4N.DeSatan", category: "Networking")

    let endpoint: URL

    init(base: URL) {
        self.endpoint = base
    }
}
