//
//  AppRouter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import UIKit

protocol IAppRouter {
    func present(_ scenario: AppRouter.AppRouterScenario)
    func dissmis()
}

final class AppRouter: IAppRouter {

    // MARK: - Scenatios

    enum AppRouterScenario {
        case login(name: String?, email: String?)
        case openApplication
    }

    // MARK: - Singltone

    static let shared = AppRouter()

    private init() { }

    // MARK: - Public variables

    var appWindow: UIWindow?

    // MARK: - IAppRouter

    func present(_ scenario: AppRouterScenario) {
        switch scenario {
        case .login(let name, let email):
            let loginDependency = LoginDependency(
                parentWindow: self.appWindow,
                initialName: name ?? "",
                initialEmail: email ?? ""
            )
            let loginRouter = LoginBuilder().build(loginDependency)
            loginRouter.start(nil)
        case .openApplication:
            let applicationContentDependency = ApplicationContentDependency(parentWindow: self.appWindow)
            let applicationContentRouter = ApplicationContentBuilder().build(dependency: applicationContentDependency)
            applicationContentRouter.start(nil)
        }

        self.appWindow?.makeKeyAndVisible()
    }

    func dissmis() {
        
    }
}
