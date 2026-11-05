//
//  RegistrationView.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 23/10/2026.
//

import SwiftUI

struct RegistrationView: View {
    @State var viewModel: RegistrationViewModel
    var body: some View {
        emailTextField
        primaryNextButton

    }

    var emailTextField: some View {
        TextField(Constans.loginTitle, text: $viewModel.loginInput)
            .padding([.leading, .trailing], 16)
            .textFieldStyle(.roundedBorder)
    }

    var primaryNextButton: some View {
        Button{
            viewModel.nextIsPressed()
        } label: {
            Text(Constans.primaryButtonTitle)
        }
        .padding()
        .background(Color(red: 0, green: 0, blue: 0.5))
        .foregroundStyle(.white)
    }
}

// MARK: - Constants
private extension RegistrationView {
    enum Constans {
        static let loginTitle = "Nickname or email"
        static let primaryButtonTitle = "Next"
    }
}
