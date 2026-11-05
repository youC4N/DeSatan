//
//  RegistrationRouter.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 04/11/2026.
//

import SwiftUI

@Observable
class RegistrationRouter: FeatureRouter {
    enum Route: Hashable {
        case otpScreen
    }

    var applicationRouter: ApplicationRouter
    var path: NavigationPath

    init(applicationRouter: ApplicationRouter, path: NavigationPath) {
        self.applicationRouter = applicationRouter
        self.path = path
    }

}
