//
//  OrganizationsListBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IOrganizationsListBuilder {
    func build(_ dependency: OrganizationsListDependency) -> IOrganizationsListRouter
}

final class OrganizationsListBuilder: IOrganizationsListBuilder {
    
    func build(_ dependency: OrganizationsListDependency) -> IOrganizationsListRouter {
        let view = OrganizationsListView()
        let router = OrganizationsListRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = OrganizationsListInteractor()
        let presenter =  OrganizationsListPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
