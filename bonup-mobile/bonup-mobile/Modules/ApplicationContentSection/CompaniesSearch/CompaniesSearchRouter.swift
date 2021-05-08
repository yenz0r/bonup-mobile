//
//  CompanySearchRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompaniesSearchRouter {

    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: CompaniesSearchRouter.RouterScenario)
}

final class CompaniesSearchRouter {
    
    enum RouterScenario {

        case showErrorAlert
        case showCompanyDescription(CompanyEntity)
    }

    private var view: CompaniesSearchView?
    private var parentNavigationController: UINavigationController

    init(view: CompaniesSearchView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICategoriesRouter implementation

extension CompaniesSearchRouter: ICompaniesSearchRouter {

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

        case .showErrorAlert:
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_help_title".localized,
                description: "ui_error_title".localized,
                from: view,
                completion: nil
            )
            
        case .showCompanyDescription(let company):
            
            let companyDependency = AddCompanyDependency(
                parentNavigationController: self.parentNavigationController,
                initCompany: company)
            let builder = AddCompanyBuilder()
            let router = builder.build(companyDependency)
            
            router.start(nil)
        }
    }
}
