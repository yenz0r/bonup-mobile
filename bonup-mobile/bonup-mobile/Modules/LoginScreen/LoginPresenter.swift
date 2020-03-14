//
//  LoginPresenter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ILoginPresenter {
    func handleResetPasswordButtonTap(with email: String?)
}

final class LoginPresenter {
    private weak var view: ILoginView?
    private let interactor: ILoginInteractor
    private let router: ILoginRouter

    init(interactor: ILoginInteractor,
         router: ILoginRouter,
         view: ILoginView) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
}

extension LoginPresenter: ILoginPresenter {
    func handleResetPasswordButtonTap(with email: String?) {
        self.router.show(.resetPassword(email: email))
    }
}
