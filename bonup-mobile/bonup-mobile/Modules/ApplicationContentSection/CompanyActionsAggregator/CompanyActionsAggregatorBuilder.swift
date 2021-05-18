//
//  CompanyActionsAggregatorBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyActionsAggregatorBuilder {

    func build(_ dependency: CompanyActionsAggregatorDependency) -> ICompanyActionsAggregatorRouter
}

final class CompanyActionsAggregatorBuilder: ICompanyActionsAggregatorBuilder {

    func build(_ dependency: CompanyActionsAggregatorDependency) -> ICompanyActionsAggregatorRouter {

        let view = CompanyActionsAggregatorView()
        let router = CompanyActionsAggregatorRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = CompanyActionsAggregatorInteractor(companyName: dependency.companyName)
        let presenter = CompanyActionsAggregatorPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
