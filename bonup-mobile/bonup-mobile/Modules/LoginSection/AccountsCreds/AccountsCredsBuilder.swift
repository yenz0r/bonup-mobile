//
//  AccountsCredsBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IAccountsCredsBuilder {

    func build(_ dependency: AccountsCredsDependency) -> IAccountsCredsRouter
}

final class AccountsCredsBuilder: IAccountsCredsBuilder {

    func build(_ dependency: AccountsCredsDependency) -> IAccountsCredsRouter {

        let view = AccountsCredsView()
        let router = AccountsCredsRouter(view: view,
                                         parentController: dependency.parentController,
                                         onTeminate: dependency.onTerminate)
        let interactor = AccountsCredsInteractor()
        let presenter = AccountsCredsPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
