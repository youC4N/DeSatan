//
//  LoginViewModel.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 23/10/2026.
//

import SwiftUI

@Observable class LoginViewModel {
    var router: LoginRouter
    var loginInput = ""
    var passwordInput = ""

    init(router: LoginRouter) {
        self.router = router
    }

    func registrationOnTap() {
        router.push(.registration)
    }

    func loginOnTap() {
        router.loginTap()
    }
}
