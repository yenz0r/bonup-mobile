//
//  ResetPasswordRouter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IResetPasswordRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: ResetPasswordRouter.ResetPasswordRouterScenario)
}

final class ResetPasswordRouter {
    enum ResetPasswordRouterScenario {
        case emailVerification
        case errorAlert(message: String)
    }

    private var view: ResetPasswordView?
    private var parentController: UIViewController?

    init(view: ResetPasswordView?, parentController: UIViewController?) {
        self.view = view
        self.parentController = parentController
    }
}

extension ResetPasswordRouter: IResetPasswordRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentController?.navigationController?.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentController?.navigationController?.popViewController(animated: true)
        self.view = nil

        completion?()
    }

    func show(_ scenario: ResetPasswordRouterScenario) {
        guard let view = self.view else { return }

        switch scenario {
        case .emailVerification:
            let dependency = AuthVerificationDependency(parentViewController: view, usageType: .resetPassword)
            let router = AuthVerificationBuilder().build(dependency)
            router.start(nil)

        case .errorAlert(let message):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_error_title".localized,
                description: message,
                from: view,
                completion: nil
            )
        }
    }
}

