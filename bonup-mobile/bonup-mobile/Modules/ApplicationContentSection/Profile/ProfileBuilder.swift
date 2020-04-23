//
//  ProfileBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 20.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IProfileBuilder {
    func build(_ dependency: ProfileDependency) -> IProfileRouter
}

final class ProfileBuilder: IProfileBuilder {
    func build(_ dependency: ProfileDependency) -> IProfileRouter {
        let view = ProfileView()
        let router = ProfileRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
