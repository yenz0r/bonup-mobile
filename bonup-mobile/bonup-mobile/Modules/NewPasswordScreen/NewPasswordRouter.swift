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
        case empty
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
        switch scenario {
        case .empty:
            print("empty")
        }
    }
}

