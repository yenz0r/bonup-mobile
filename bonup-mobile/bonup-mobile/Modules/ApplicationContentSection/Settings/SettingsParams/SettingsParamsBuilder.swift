//
//  SettingsParamsBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ISettingsParamsBuilder {

    func build(_ dependency: SettingsParamsDependency) -> ISettingsParamsRouter
}

final class SettingsParamsBuilder: ISettingsParamsBuilder {

    func build(_ dependency: SettingsParamsDependency) -> ISettingsParamsRouter {

        let view = SettingsParamsView()
        let router = SettingsParamsRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = SettingsParamsInteractor(settingsParamsType: dependency.settingsParamsType)
        let presenter = SettingsParamsPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
