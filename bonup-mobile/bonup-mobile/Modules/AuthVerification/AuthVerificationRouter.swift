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
        switch scenario {
        case .openApplication:
            print("empty")
        }
    }
}

