//
//  FeatureRouter.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 23/10/2026.
//

import SwiftUI

protocol FeatureRouter {
    associatedtype Route: Hashable
    var applicationRouter: ApplicationRouter { get }
    var path: NavigationPath { get set }
    mutating func push(_ route: Route)
    mutating func pop()
    mutating func popToRoot()
}

extension FeatureRouter {
    mutating func push(_ route: Route) {
        path.append(route)
    }

    mutating func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    mutating func popToRoot() {
        path.removeLast(path.count)
    }
}
