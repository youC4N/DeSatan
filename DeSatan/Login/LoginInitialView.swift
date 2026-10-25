//
//  LoginInitialView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 23/10/2026.
//

import SwiftUI

struct LoginInitialView: View {
    @State var router: LoginRouter

    init(applicationRouter: ApplicationRouter) {
        _router = State(initialValue: LoginRouter(applicationRouter: applicationRouter))
    }
    var body: some View {
        NavigationStack(path: $router.path) {
            LoginView(viewModel: LoginViewModel(router: router))
                .navigationDestination(for: LoginRouter.Route.self) { route in
                    switch route{
                    case .registration: RegistrationView()
                    }
                }
        }
    }
}

#Preview {
    LoginInitialView(applicationRouter: ApplicationRouter())
}
