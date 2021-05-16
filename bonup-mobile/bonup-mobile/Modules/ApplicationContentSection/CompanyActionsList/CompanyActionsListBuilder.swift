//
//  CompanyActionsListBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyActionsListBuilder {

    func build(_ dependency: CompanyActionsListDependency) -> ICompanyActionsListRouter
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
            mode: dependency.mode
        )
        let presenter = CompanyActionsListPresenter(view: view,
                                                    interactor: interactor,
                                                    router: router)
        view.presenter = presenter

        return router
    }
}
