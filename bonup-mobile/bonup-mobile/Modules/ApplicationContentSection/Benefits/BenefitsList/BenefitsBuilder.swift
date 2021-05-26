//
//  BenefitsBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IBenefitsBuilder {
    func build(_ dependency: BenefitsDependency) -> IBenefitsRouter
}

final class BenefitsBuilder: IBenefitsBuilder {
    func build(_ dependency: BenefitsDependency) -> IBenefitsRouter {
        let view = BenefitsView()
        let router = BenefitsRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = BenefitsInteractor()
        let presenter =  BenefitsPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
