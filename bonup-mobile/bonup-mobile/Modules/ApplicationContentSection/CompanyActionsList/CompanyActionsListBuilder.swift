//
//  CompanyActionsListBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyActionsListBuilder {

    func build(_ dependency: CompanyActionsListDependency) -> ICompanyActionsListRouter
    func build(_ dependency: CompanyActionsListDependency) -> UIViewController
}

final class CompanyActionsListBuilder: ICompanyActionsListBuilder {

    func build(_ dependency: CompanyActionsListDependency) -> ICompanyActionsListRouter {

        let view = CompanyActionsListView()
        let router = CompanyActionsListRouter(
            view: view,
            parentNavigationController: dependency.parentNavigationController
        )
        let interactor = CompanyActionsListInteractor(
            actions: dependency.actions,
            contentType: dependency.contentType,
            contentMode: dependency.contentMode
        )
        let presenter = CompanyActionsListPresenter(view: view,
                                                    interactor: interactor,
                                                    router: router)
        view.presenter = presenter

        return router
    }
    
    func build(_ dependency: CompanyActionsListDependency) -> UIViewController {
        
        let view = CompanyActionsListView()
        let router = CompanyActionsListRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = CompanyActionsListInteractor(
            actions: dependency.actions,
            contentType: dependency.contentType,
            contentMode: dependency.contentMode
        )
        let presenter = CompanyActionsListPresenter(view: view,
                                                    interactor: interactor,
                                                    router: router)
        view.presenter = presenter

        return view
    }
}
