//
//  AddCompanyBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IAddCompanyBuilder {

    func build(_ dependency: AddCompanyDependency) -> IAddCompanyRouter
}

final class AddCompanyBuilder: IAddCompanyBuilder {

    func build(_ dependency: AddCompanyDependency) -> IAddCompanyRouter {

        let view = AddCompanyView()
        let router = AddCompanyRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = AddCompanyInteractor()
        let presenter = AddCompanyPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
