//
//  AppRouter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import UIKit

enum AppRouterScenario {
    case login, openApplication
}

protocol IAppRouter {
    func present(_ scenario: AppRouterScenario)
    func dissmis()
}

class AppRouter: IAppRouter {
    var appWindow: UIWindow?

    static let shared = AppRouter()

    private init() { }

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
