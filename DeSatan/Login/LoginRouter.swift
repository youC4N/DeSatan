//
//  LoginRouter.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 23/10/2026.
//

import SwiftUI

@Observable
class LoginRouter: FeatureRouter {
    var applicationRouter: ApplicationRouter

    init(applicationRouter: ApplicationRouter) {
        self.applicationRouter = applicationRouter
    }

    var path = NavigationPath()

    enum Route: Hashable {
        case registration
    }

    func loginTap() {
        applicationRouter.move(to: .grid)
    }
}
