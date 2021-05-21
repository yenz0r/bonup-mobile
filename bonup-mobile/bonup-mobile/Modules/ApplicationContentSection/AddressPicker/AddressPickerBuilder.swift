//
//  AddressPickerBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IAddressPickerBuilder {

    func build(_ dependency: AddressPickerDependency) -> IAddressPickerRouter
}

final class AddressPickerBuilder: IAddressPickerBuilder {

    func build(_ dependency: AddressPickerDependency) -> IAddressPickerRouter {

        let view = AddressPickerView()
        let router = AddressPickerRouter(view: view,
                                         parentController: dependency.parentController)
        let interactor = AddressPickerInteractor(initAddress: dependency.initAdderss,
                                                 searchManager: dependency.searchManager,
                                                 suggestsManager: dependency.suggestsManager)
        let presenter = AddressPickerPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
