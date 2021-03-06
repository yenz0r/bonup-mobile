//
//  AuthVerificationRouter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IAuthVerificationRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: AuthVerificationRouter.AuthVerificationRouterScenario)
}

final class AuthVerificationRouter {
    enum AuthVerificationRouterScenario {
        case openApplication
        case errorAlert(String)
        case newPassword
        case categories
    }

    private var view: AuthVerificationView?
    private var parentController: UIViewController?

    init(view: AuthVerificationView?, parentController: UIViewController?) {
        self.view = view
        self.parentController = parentController
    }
}

extension AuthVerificationRouter: IAuthVerificationRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentController?.navigationController?.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentController?.navigationController?.popToRootViewController(animated: true)
        completion?()
        self.view = nil
    }

    func show(_ scenario: AuthVerificationRouterScenario) {

        guard let view = self.view else { return }

        switch scenario {
        case .openApplication:
            AppRouter.shared.present(.openApplication)
        case .categories:
            let categoriesDependency = CategoriesDependency(parentViewController: view,
                                                            target: .login)
            let categoriesRouter = CategoriesBuilder().build(categoriesDependency)
            categoriesRouter.start(nil)
        case .newPassword:
            let newPasswordDependency = NewPasswordDependency(parentViewController: view)
            let newPassowrdRouter = NewPasswordBuilder().build(newPasswordDependency)
            newPassowrdRouter.start(nil)
        case .errorAlert(let message):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_incorrect_verification_title".localized,
                description: message,
                from: view,
                completion: nil
            )
        }
    }
}

