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
        case login, openApplication
    }

    // MARK: - Singltone

    static let shared = AppRouter()

    private init() { }

    // MARK: - Public variables

    var appWindow: UIWindow?

    // MARK: - IAppRouter

    func present(_ scenario: AppRouterScenario) {
        switch scenario {
        case .login:
            let loginDependency = LoginDependency(parentWindow: self.appWindow, initialName: "", initialEmail: "")
            let loginRouter = LoginBuilder().build(loginDependency)
            loginRouter.start(nil)
            self.appWindow?.makeKeyAndVisible()
        case .openApplication:
            print("openApplication")
        }
    }

    func dissmis() {
        
    }
}
