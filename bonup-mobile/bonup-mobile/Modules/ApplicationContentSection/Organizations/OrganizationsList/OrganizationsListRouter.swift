//
//  OrganizationsListRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IOrganizationsListRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: OrganizationsListRouter.RouterScenario)
}

final class OrganizationsListRouter {
    enum RouterScenario {

        case showOrganizationControl(CompanyEntity)
        case showAddNewOrganization(onStop: (() -> Void)?)
    }

    private var view: OrganizationsListView?
    private var parentNavigationController: UINavigationController

    init(view: OrganizationsListView?, parentNavigationController: UINavigationController) {
        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICategoriesRouter implementation

extension OrganizationsListRouter: IOrganizationsListRouter {
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

    func show(_ scenario: RouterScenario) {
        guard let view = self.view else { return }

        switch scenario {

        case .showOrganizationControl(let company):
            
            let dependency = OrganizationControlDependency(parentController: view,
                                                           company: company)
            let builder = OrganizationControlBuilder()
            let router = builder.build(dependency)
            router.start(nil)

        case .showAddNewOrganization(let onStop):

            let dependency = CompanyPacketDependency(parentNavigationController: self.parentNavigationController)
            let builder = CompanyPacketBuilder()
            let router = builder.build(dependency)
            
            router.start(onStop: onStop)
        }
    }
}

