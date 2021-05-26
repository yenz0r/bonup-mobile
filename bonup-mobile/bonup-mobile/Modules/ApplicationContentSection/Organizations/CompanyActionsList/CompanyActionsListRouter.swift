//
//  CompanyActionsListRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyActionsListRouter {

    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: CompanyActionsListRouter.RouterScenario)
}

final class CompanyActionsListRouter {

    enum RouterScenario {

        case showActionDetails(mode: CompanyActionsListDependency.ContentType,
                               action: OrganizationActionEntity)
    }

    private var view: CompanyActionsListView?
    private var parentNavigationController: UINavigationController

    init(view: CompanyActionsListView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICompanyPacketRouter implementation

extension CompanyActionsListRouter: ICompanyActionsListRouter {

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

        switch scenario {

        case .showActionDetails(let mode, let action):
            
            let listMode: CompanyActionType
            
            switch mode {
            case .coupons:
                listMode = .coupon
                
            case .tasks:
                listMode = .task
                
            case .stocks:
                listMode = .stock
            }
            
            let dependecy = AddCompanyActionDependency(
                parentNavigationController: self.parentNavigationController,
                actionType: listMode,
                organizationId: nil,
                action: action,
                mode: .read
            )
            let builder = AddCompanyActionBuilder()
            let router = builder.build(dependecy)
            
            router.start(nil)
            
        }
    }
}
