//
//  LoginInitialView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 23/10/2026.
//

import SwiftUI

struct LoginInitialView: View {
    @State var router: LoginRouter
    let applicationRouter: ApplicationRouter

    init(applicationRouter: ApplicationRouter) {
        self.applicationRouter = applicationRouter
        _router = State(initialValue: LoginRouter(applicationRouter: applicationRouter))
    }
    var body: some View {
        NavigationStack(path: $router.path) {
            LoginView(viewModel: LoginViewModel(router: router))
                .navigationDestination(for: LoginRouter.Route.self) { route in
                    switch route{
                    case .registration: RegistrationView(viewModel: RegistrationViewModel(router: RegistrationRouter(applicationRouter: applicationRouter, path: router.path)))
                    }
                }
        }
    }
}

#Preview {
    LoginInitialView(applicationRouter: ApplicationRouter())
}
