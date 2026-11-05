//
//  DeSatanApp.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 14.02.2026.
//
import OSLog
import SwiftUI

let logger = Logger(subsystem: "com.github.youC4N.videomessenger", category: "UI")

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
