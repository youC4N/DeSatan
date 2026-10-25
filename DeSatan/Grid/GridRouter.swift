//
//  GridRouter.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 23/10/2026.
//

import SwiftUI

@Observable
class GridRouter: FeatureRouter {
    var applicationRouter: ApplicationRouter

    init(applicationRouter: ApplicationRouter) {
        self.applicationRouter = applicationRouter
    }

    var path = NavigationPath()

    enum Route: Hashable {
        case foo
    }

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
