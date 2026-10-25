//
//  File.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 23/10/2026.
//

import Foundation
import SwiftUI

@Observable
class ApplicationRouter {
    enum Flow {
        case login
        case grid
    }

    var flow = Flow.login

    func move(to flow: Flow) {
        self.flow = flow
    }
    func reset() {
        self.flow = .login
    }
}
