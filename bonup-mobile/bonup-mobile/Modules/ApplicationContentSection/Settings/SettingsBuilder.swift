//
//  SettingsBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ISettingsBuilder {
    func build(_ dependency: SettingsDependency) -> ISettingsRouter
}

final class SettingsBuilder: ISettingsBuilder {
    func build(_ dependency: SettingsDependency) -> ISettingsRouter {
        let view = SettingsView()
        let router = SettingsRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = SettingsInteractor()
        let presenter =  SettingsPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
