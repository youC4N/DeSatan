//
//  RegistrationViewModel.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 04/11/2026.
//

import SwiftUI

@Observable
class RegistrationViewModel {
    var otpToken: OTPToken?
    var router: RegistrationRouter
    var loginInput = ""

    init(router: RegistrationRouter) {
        self.router = router
    }

    func nextIsPressed() {
        Task {
            do {
                switch try await API.local.requestOTP(forPhoneNumber: loginInput) {
                case .invalidPhoneNumber(reason: _): break  // TODO: Display an error to the user
                case .success(let payload): self.otpToken = payload.otpToken
                }
            } catch let e {
                logger.error(
                    "when requesting otp an error occured: \(e, privacy: .public)"
                )
            }
        }
        router.push(.otpScreen)
    }
}
