//
//  CompaniesSectionBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompaniesSectionBuilder {

    func build(_ dependency: CompaniesSectionDependency) -> ICompaniesSectionRouter
}

final class CompaniesSectionBuilder: ICompaniesSectionBuilder {

    func build(_ dependency: CompaniesSectionDependency) -> ICompaniesSectionRouter {

        let view = CompaniesSectionView()
        let router = CompaniesSectionRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = CompaniesSectionInteractor()
        let presenter = CompaniesSectionPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
