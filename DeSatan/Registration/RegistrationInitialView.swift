//
//  RegistrationInitialView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 04/11/2026.
//

import SwiftUI

struct RegistrationInitialView: View {
    @State var router: RegistrationRouter

    init(router: RegistrationRouter){
        _router = State(initialValue: router)
    }
    var body: some View {
        NavigationStack(path: $router.path) {
            RegistrationView(viewModel: RegistrationViewModel(router: router))
                .navigationDestination(for: RegistrationRouter.Route.self) { route in
                    switch route{
                    case .otpScreen: OTPScreen()
                    }
                }
        }
    }
}
