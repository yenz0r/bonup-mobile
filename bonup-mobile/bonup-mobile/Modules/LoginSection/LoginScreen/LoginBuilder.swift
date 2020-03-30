//
//  LoginBuilder.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ILoginBuilder {
    func build(_ dependency: LoginDependency) -> ILoginRouter
}

final class LoginBuilder: ILoginBuilder {
    func build(_ dependency: LoginDependency) -> ILoginRouter {
        let view = LoginView()
        let router = LoginRouter(view: view, parentWindow: dependency.parentWindow)
        let interactor = LoginInteractor()
        let presenter =  LoginPresenter(interactor: interactor, router: router, view: view)
        view.presenter = presenter

        return router
    }
}
