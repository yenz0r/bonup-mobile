//
//  CompaniesSectionRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompaniesSectionRouter {

    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: CompaniesSectionRouter.CompaniesSectionRouterScenario)
}

final class CompaniesSectionRouter {

    enum CompaniesSectionRouterScenario {
        case infoAlert(String?)
    }

    private var view: CompaniesSectionView?
    private var parentNavigationController: UINavigationController

    init(view: CompaniesSectionView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICompaniesSectionRouter implementation

extension CompaniesSectionRouter: ICompaniesSectionRouter {

    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentNavigationController.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentNavigationController.popViewController(animated: true)
        self.view = nil

        completion?()
    }

    func show(_ scenario: CompaniesSectionRouterScenario) {
        guard let view = self.view else { return }

        switch scenario {
        case .infoAlert(let message):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_organization_title".localized,
                description: message ?? "",
                from: view,
                completion: nil
            )
        }
    }
}
