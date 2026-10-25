//
//  DeSatanApp.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 14.02.2026.
//

import SwiftUI

@main
struct DeSatanApp: App {
    @State private var appRouter = ApplicationRouter()

    var body: some Scene {
        WindowGroup {
            switch appRouter.flow {
            case .grid: ContentView(applicationRouter: appRouter)
            case .login: LoginInitialView(applicationRouter: appRouter)

            }
        }
    }
}
