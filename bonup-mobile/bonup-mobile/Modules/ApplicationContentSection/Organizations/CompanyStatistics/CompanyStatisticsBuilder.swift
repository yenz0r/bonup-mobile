//
//  CompanyStatisticsBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 2.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyStatisticsBuilder {

    func build(_ dependency: CompanyStatisticsDependency) -> ICompanyStatisticsRouter
}

final class CompanyStatisticsBuilder: ICompanyStatisticsBuilder {

    func build(_ dependency: CompanyStatisticsDependency) -> ICompanyStatisticsRouter {

        let view = CompanyStatisticsView()
        let router = CompanyStatisticsRouter(view: view,
                                             parentNavigationController: dependency.parentNavigationController)
        let interactor = CompanyStatisticsInteractor(
            companyId: dependency.organizationId
        )
        let presenter = CompanyStatisticsPresenter(view: view,
                                                   interactor: interactor,
                                                   router: router)
        view.presenter = presenter

        return router
    }
}
