//
//  CompanySearchBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompaniesSearchBuilder {

    func build(_ dependency: CompaniesSearchDependency) -> UIViewController
}

final class CompaniesSearchBuilder: ICompaniesSearchBuilder {

    func build(_ dependency: CompaniesSearchDependency) -> UIViewController {

        let view = CompaniesSearchView()
        let router = CompaniesSearchRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = CompaniesSearchInteractor()
        let presenter = CompaniesSearchPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return view
    }
}
