//
//  CompanyPacketBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyPacketBuilder {

    func build(_ dependency: CompanyPacketDependency) -> ICompanyPacketRouter
}

final class CompanyPacketBuilder: ICompanyPacketBuilder {

    func build(_ dependency: CompanyPacketDependency) -> ICompanyPacketRouter {

        let view = CompanyPacketView()
        let router = CompanyPacketRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = CompanyPacketInteractor()
        let presenter = CompanyPacketPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
