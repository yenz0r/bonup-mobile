//
//  ChangePasswordRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IChangePasswordRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: ChangePasswordRouter.ChangePasswordRouterScenario)
}

final class ChangePasswordRouter {
    enum ChangePasswordRouterScenario {
        case close
        case showErrorAlert(String)
    }

    private var view: ChangePasswordView?
    private var parentController: UIViewController

    init(view: ChangePasswordView?, parentController: UIViewController) {
        self.view = view
        self.parentController = parentController
    }
}

// MARK: - ICategoriesRouter implementation

extension ChangePasswordRouter: IChangePasswordRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentController.navigationController?.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentController.navigationController?.popViewController(animated: true)
        completion?()
        self.view = nil
    }

    func show(_ scenario: ChangePasswordRouterScenario) {
        guard let view = self.view else { return }

        switch scenario {
        case .close:
            self.stop(nil)
        case .showErrorAlert(let message):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_error_title".localized,
                description: message,
                from: view,
                completion: {
                    print("error")
                }
            )
        }
    }

}
