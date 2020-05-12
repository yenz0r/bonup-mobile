//
//  NewPasswordRouter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol INewPasswordRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: NewPasswordRouter.NewPasswordRouterScenario)
}

final class NewPasswordRouter {
    enum NewPasswordRouterScenario {
        case login
        case showErrorAlert(String)
    }

    private var view: NewPasswordView?
    private var parentController: UIViewController?

    init(view: NewPasswordView?, parentController: UIViewController?) {
        self.view = view
        self.parentController = parentController
    }
}

extension NewPasswordRouter: INewPasswordRouter {
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

    func show(_ scenario: NewPasswordRouterScenario) {
        guard let view = self.view else { return }
        
        switch scenario {
        case .login:
            self.stop(nil)
        case .showErrorAlert(let message):
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

