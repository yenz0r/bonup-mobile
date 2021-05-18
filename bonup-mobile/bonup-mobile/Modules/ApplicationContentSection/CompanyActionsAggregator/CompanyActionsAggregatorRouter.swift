//
//  CompanyActionsAggregatorRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyActionsAggregatorRouter {

    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: CompanyActionsAggregatorRouter.RouterScenario)
}

final class CompanyActionsAggregatorRouter {

    enum RouterScenario {
        case infoAlert(String?)
    }

    private var view: CompanyActionsAggregatorView?
    private var parentNavigationController: UINavigationController

    init(view: CompanyActionsAggregatorView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICompaniesSectionRouter implementation

extension CompanyActionsAggregatorRouter: ICompanyActionsAggregatorRouter {

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

    func show(_ scenario: RouterScenario) {
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
