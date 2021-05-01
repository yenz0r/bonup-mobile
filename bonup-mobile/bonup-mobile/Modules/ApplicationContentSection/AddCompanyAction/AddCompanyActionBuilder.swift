//
//  AddCompanyActionBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 25.04.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IAddCompanyActionBuilder {

    func build(_ dependency: AddCompanyActionDependency) -> IAddCompanyActionRouter
}

final class AddCompanyActionBuilder: IAddCompanyActionBuilder {

    func build(_ dependency: AddCompanyActionDependency) -> IAddCompanyActionRouter {

        let view = AddCompanyActionView()
        let router = AddCompanyActionRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = AddCompanyActionInteractor(
            actionType: dependency.actionType,
            organizationId: dependency.organizationId
        )
        let presenter = AddCompanyActionPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
