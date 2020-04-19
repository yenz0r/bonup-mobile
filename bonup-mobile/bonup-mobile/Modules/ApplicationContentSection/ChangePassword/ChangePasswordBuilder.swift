//
//  ChangePasswordBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IChangePasswordBuilder {
    func build(_ dependency: ChangePasswordDependency) -> IChangePasswordRouter
}

final class ChangePasswordBuilder: IChangePasswordBuilder {
    func build(_ dependency: ChangePasswordDependency) -> IChangePasswordRouter {
        let view = ChangePasswordView()
        let router = ChangePasswordRouter(view: view, parentController: dependency.parentController)
        let interactor = ChangePasswordInteractor()
        let presenter =  ChangePasswordPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
