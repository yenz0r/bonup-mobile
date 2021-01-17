//
//  ProfileRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 20.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IProfileRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: ProfileRouter.ProfileRouterScenario)
}

final class ProfileRouter {
    enum ProfileRouterScenario {
        case infoAlert(String?)
    }

    private var view: ProfileView?
    private var parentNavigationController: UINavigationController

    init(view: ProfileView?, parentNavigationController: UINavigationController) {
        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICategoriesRouter implementation

extension ProfileRouter: IProfileRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentNavigationController.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentNavigationController.popViewController(animated: true)
        completion?()
        self.view = nil
    }

    func show(_ scenario: ProfileRouterScenario) {
        guard let view = self.view else { return }
        
        switch scenario {
        case .infoAlert(let message):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_profile_title".localized,
                description: message ?? "ui_profile_help".localized,
                from: view,
                completion: nil
            )
        }
    }
}
