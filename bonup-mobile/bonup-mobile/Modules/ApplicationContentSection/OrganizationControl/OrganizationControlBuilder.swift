//
//  OrganizationControlBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IOrganizationControlBuilder {
    
    func build(_ dependency: OrganizationControlDependency) -> IOrganizationControlRouter
}

final class OrganizationControlBuilder: IOrganizationControlBuilder {

    func build(_ dependency: OrganizationControlDependency) -> IOrganizationControlRouter {
        let view = OrganizationControlView()
        let router = OrganizationControlRouter(view: view, parentController: dependency.parentController)
        let interactor = OrganizationControlInteractor(organizationName: dependency.organizationName)
        let presenter =  OrganizationControlPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
