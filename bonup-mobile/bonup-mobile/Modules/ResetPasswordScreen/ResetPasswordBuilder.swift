//
//  ResetPasswordBuilder.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IResetPasswordBuilder {
    func build(_ dependency: ResetPasswordDependency) -> IResetPasswordRouter
}

final class ResetPasswordBuilder: IResetPasswordBuilder {
    func build(_ dependency: ResetPasswordDependency) -> IResetPasswordRouter {
        let view = ResetPasswordView()
        let router = ResetPasswordRouter(view: view, parentController: dependency.parentController)
        let interactor = ResetPasswordInteractor()
        let presenter =  ResetPasswordPresenter(interactor: interactor, router: router, view: view, email: dependency.initialEmail)
        view.presenter = presenter

        return router
    }
}
