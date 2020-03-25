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
            let currentName = name,
            let currentEmail = email,
            let currentPassword = password,

            currentName != "",
            currentEmail != "",
            currentPassword != ""

        else {
            self.router.show(
                .alert(
                    isError: true,
                    title: "ui_alert_incorrect_auth_params".localized,
                    description: "ui_alert_incorrect_auth_params_description".localized
                )
            )
            return
        }

        guard currentEmail.isEmail else {
            self.router.show(
                .alert(
                    isError: true,
                    title: "ui_auth_email_error_title".localized,
                    description: "ui_auth_email_error_description".localized
                )
            )
            return
        }

        self.router.show(.authVerification)
        return

        let authParams = AuthParams(
            name: currentName,
            email: currentEmail,
            password: currentPassword
        )
        
        self.interactor.handleLoginRequest(
            for: type,
            with: authParams,
            completion: { [weak self] isSuccess in
                DispatchQueue.main.async {
                    if isSuccess {
                        self?.router.show(.authVerification)
                    } else {
                        self?.router.show(
                            .alert(
                                isError: true,
                                title: "ui_auth_error_title".localized,
                                description: "ui_auth_error_description".localized
                            )
                        )
                    }
                }
            }
        )
    }

    func handleResetPasswordButtonTap(with email: String?) {
        self.router.show(.resetPassword(email: email))
    }
}
