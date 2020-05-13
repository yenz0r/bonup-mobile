//
//  OrganizationControl.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IOrganizationControlRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: OrganizationControlRouter.RouterScenario)
}

final class OrganizationControlRouter {
    enum RouterScenario {

        case showResultAlert(String)
    }

    private var view: OrganizationControlView?
    private var parentController: UIViewController

    init(view: OrganizationControlView?, parentController: UIViewController) {
        self.view = view
        self.parentController = parentController
    }
}

// MARK: - ICategoriesRouter implementation

extension OrganizationControlRouter: IOrganizationControlRouter {
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

    func show(_ scenario: RouterScenario) {
        
        guard let view = self.view else { return }

        switch scenario {

        case .showResultAlert(let message):
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
