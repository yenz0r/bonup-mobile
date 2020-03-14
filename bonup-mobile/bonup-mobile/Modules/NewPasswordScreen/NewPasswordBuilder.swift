//
//  NewPasswordBuilder.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol INewPasswordBuilder {
    func build(_ dependency: NewPasswordDependency) -> INewPasswordRouter
}

final class NewPasswordBuilder: INewPasswordBuilder {
    func build(_ dependency: NewPasswordDependency) -> INewPasswordRouter {
        let view = NewPasswordView()
        let router = NewPasswordRouter(view: view, parentController: dependency.parentViewController)
        let interactor = NewPasswordInteractor()
        let presenter =  NewPasswordPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
