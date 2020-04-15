//
//  AuthVerificationBuilder.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IAuthVerificationBuilder {
    func build(_ dependency: AuthVerificationDependency) -> IAuthVerificationRouter
}

final class AuthVerificationBuilder: IAuthVerificationBuilder {
    func build(_ dependency: AuthVerificationDependency) -> IAuthVerificationRouter {
        let view = AuthVerificationView()
        let router = AuthVerificationRouter(view: view, parentController: dependency.parentViewController)
        let interactor = AuthVerificationInteractor()
        let presenter =  AuthVerificationPresenter(
            view: view,
            interactor: interactor,
            router: router,
            usageType: dependency.usageType)
        view.presenter = presenter

        return router
    }
}
