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
    func handleSignButtonTap(name: String?, email: String?, password: String?, type: LoginInteractor.LoginRequest)
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
    func handleSignButtonTap(name: String?,
                             email: String?,
                             password: String?,
                             type: LoginInteractor.LoginRequest) {
        guard
            let name = name,
            let email = email,
            let password = password
        else { return }

        let authParams = AuthParams(name: name, email: email, password: password)
        self.interactor.handleLoginRequest(
            for: type,
            with: authParams,
            completion: { [weak self] isSuccess in
                DispatchQueue.main.async {
                    if isSuccess {
                        self?.router.show(.openApp)
                    } else {
                        self?.router.show(.alert(isError: true))
                    }
                }
            }
        )
    }

    func handleResetPasswordButtonTap(with email: String?) {
        self.router.show(.resetPassword(email: email))
    }
}
