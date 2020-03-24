//
//  LoginRouter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import PMAlertController

protocol ILoginRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: LoginRouter.LoginRouterScenario)
}

final class LoginRouter {
    enum LoginRouterScenario {
        case alert(isError: Bool)
        case resetPassword(email: String?)
        case openApp
    }

    private var view: LoginView?
    private var parentWindow: UIWindow?

    init(view: LoginView?, parentWindow: UIWindow?) {
        self.view = view
        self.parentWindow = parentWindow
    }
}

// MARK: - ILoginRouter implementation

extension LoginRouter: ILoginRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        let navigationController = UINavigationController.init(rootViewController: view)
        self.parentWindow?.rootViewController = navigationController
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentWindow?.rootViewController = nil
        self.view = nil
        completion?()
    }

    func show(_ scenario: LoginRouterScenario) {
        guard let view = self.view else { return }

        switch scenario {
        case .resetPassword(let email):
            let resetPasswordDependency = ResetPasswordDependency(parentController: view, initialEmail: email)
            let resetPasswordRouter = ResetPasswordBuilder().build(resetPasswordDependency)
            resetPasswordRouter.start(nil)
        case .openApp:
            print("openApp")
        case .alert(_):
            let alertVC = PMAlertController(
                title: "ui_alert_incorrect_auth_params".localized,
                description: "ui_alert_incorrect_auth_params_description".localized,
                image: AssetsHelper.shared.image(.flagIcon),
                style: .alert
            )

            alertVC.addAction(
                PMAlertAction(
                    title: "ui_ok".localized,
                    style: .default,
                    action: {
                        print("Capture action OK")
                    }
                )
            )

            view.present(alertVC, animated: true, completion: nil)
        }
    }
}