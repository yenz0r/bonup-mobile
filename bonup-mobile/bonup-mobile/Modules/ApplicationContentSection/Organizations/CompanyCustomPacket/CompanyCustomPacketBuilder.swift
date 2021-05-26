//
//  CompanyCustomPacketBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyCustomPacketBuilder {

    func build(_ dependency: CompanyCustomPacketDependency) -> ICompanyCustomPacketRouter
}

final class CompanyCustomPacketBuilder: ICompanyCustomPacketBuilder {

    func build(_ dependency: CompanyCustomPacketDependency) -> ICompanyCustomPacketRouter {

        let view = CompanyCustomPacketView()
        let router = CompanyCustomPacketRouter(view: view,
                                               parentController: dependency.parentController)
        let interactor = CompanyCustomPacketInteractor()
        let presenter = CompanyCustomPacketPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
