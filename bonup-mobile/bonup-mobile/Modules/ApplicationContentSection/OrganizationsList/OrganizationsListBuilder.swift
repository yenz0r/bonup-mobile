//
//  OrganizationsListBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IOrganizationsListBuilder {
    func build(_ dependency: OrganizationsListDependency) -> UIViewController
}

final class OrganizationsListBuilder: IOrganizationsListBuilder {
    
    func build(_ dependency: OrganizationsListDependency) -> UIViewController {
        let view = OrganizationsListView()
        let router = OrganizationsListRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = OrganizationsListInteractor()
        let presenter =  OrganizationsListPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return view
    }
}
