//
//  NewPasswordPresenter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol INewPasswordPresenter {
    func handleSendButtonTapped(newPass: String?, repeatPass: String?)
}

final class NewPasswordPresenter {
    private weak var view: INewPasswordView?
    private let interactor: INewPasswordInteractor
    private let router: INewPasswordRouter

    init(view: INewPasswordView?, interactor: INewPasswordInteractor, router: INewPasswordRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - INewPasswordPresenter implementation

extension NewPasswordPresenter: INewPasswordPresenter {
    func handleSendButtonTapped(newPass: String?, repeatPass: String?) {

        guard
            let newText = newPass,
            let repeatText = repeatPass,

            newText != "",
            repeatText == newText else {
                self.view?.animateSendButtonOnError()
                return
        }

        self.interactor.setupNewPasswordRequest(newText) { resultBool, errMessage in
            if resultBool {
                self.router.show(.openApp)
            } else {
                self.router.show(.showErrorAlert(errMessage))
            }
        }

    }
}
