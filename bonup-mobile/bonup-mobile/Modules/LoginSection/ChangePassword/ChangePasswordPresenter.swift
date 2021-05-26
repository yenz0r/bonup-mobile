//
//  ChangePasswordPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IChangePasswordPresenter: AnyObject {
    func handleChangeButtonTap(oldPass: String?, newPass: String?, repeatPass: String?)
}

final class ChangePasswordPresenter {
    private weak var view: IChangePasswordView?
    private let interactor: IChangePasswordInteractor
    private let router: IChangePasswordRouter

    init(view: IChangePasswordView?, interactor: IChangePasswordInteractor, router: IChangePasswordRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskSelectionPresenter implementation

extension ChangePasswordPresenter: IChangePasswordPresenter {
    func handleChangeButtonTap(oldPass: String?, newPass: String?, repeatPass: String?) {
        guard
            let oldPass = oldPass,
            let newPass = newPass,
            let repeatPass = repeatPass
            else { self.router.show(.showErrorAlert("ui_empty_fields".localized)); return }

        guard
            let password = AccountManager.shared.currentUser?.password,
            password == oldPass
            else { self.router.show(.showErrorAlert("ui_old_password_invalid".localized)); return }

        guard
            newPass == repeatPass
            else { self.router.show(.showErrorAlert("ui_new_repeat_password_error".localized)); return }

        self.interactor.requestUpdatePassword(
            newPassword: newPass,
            success: { [weak self] in
                self?.router.show(.close)
            },
            failure: { [weak self] err in
                self?.router.show(.showErrorAlert(err))
            }
        )
    }
}

