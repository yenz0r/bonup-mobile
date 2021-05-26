//
//  AccountsCredsRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import UIKit

protocol IAccountsCredsRouter {

    func start(_ completion: (() -> Void)?)
    func stop(_ creds: AuthCredRealmObject)
}

final class AccountsCredsRouter {

    private var view: AccountsCredsView?
    private var parentController: UIViewController
    private var onTeminate: ((AuthCredRealmObject) -> Void)?

    init(view: AccountsCredsView?,
         parentController: UIViewController,
         onTeminate: ((AuthCredRealmObject) -> Void)?) {

        self.view = view
        self.parentController = parentController
        self.onTeminate = onTeminate
    }
}

// MARK: - IAccountsCredsRouter implementation

extension AccountsCredsRouter: IAccountsCredsRouter {

    func start(_ completion: (() -> Void)?) {
        
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentController.navigationController?.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ creds: AuthCredRealmObject) {
        
        self.onTeminate?(creds)
        
        self.view?.navigationController?.popToRootViewController(animated: true)
        self.view = nil
    }
}
