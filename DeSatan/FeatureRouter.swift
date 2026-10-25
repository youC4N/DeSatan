//
//  FeatureRouter.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 23/10/2026.
//

import SwiftUI

protocol FeatureRouter {
    associatedtype Route: Hashable
    var applicationRouter: ApplicationRouter { get }
    var path: NavigationPath { get set }
    func push(_ route: Route)
    func pop()
    func popToRoot()
}
