//
//  LoginView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 23/10/2026.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Spacer()
            nicknameTextField
            passwordTextField
            primaryNextButton
            Spacer()
            registrationButton
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(router: LoginRouter(applicationRouter: ApplicationRouter())))
}

// MARK: - Views
private extension LoginView {
    var nicknameTextField: some View {
        TextField(Constans.loginTitle, text: $viewModel.loginInput)
            .padding([.leading, .trailing], 16)
            .textFieldStyle(.roundedBorder)
    }

    var passwordTextField: some View {
        TextField(Constans.passwordTitle, text: $viewModel.passwordInput)
            .padding([.leading, .trailing], 16)
            .textFieldStyle(.roundedBorder)
    }

    var primaryNextButton: some View {
        Button{
            // view model call for password check
            viewModel.loginOnTap()
        } label: {
            Text(Constans.primaryButtonTitle)
        }
        .padding()
        .background(Color(red: 0, green: 0, blue: 0.5))
        .foregroundStyle(.white)
    }

    var registrationButton: some View {
        Button {
            // view model navigation to registration screen
            viewModel.registrationOnTap()
        } label: {
            Text(Constans.registrationButtonTitle)
        }
    }
}

// MARK: - Constants
private extension LoginView {
    enum Constans {
        static let loginTitle = "Nickname or email"
        static let passwordTitle = "password"
        static let primaryButtonTitle = "Login"
        static let registrationButtonTitle = "Register"
    }
}
