//
//  ResetPasswordPresenter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IResetPasswordPresenter {
    func handleSendButtonTapped(_ email: String?)
    func viewDidLoad()
}

final class ResetPasswordPresenter {

    private weak var view: IResetPasswordView?
    private let interactor: IResetPasswordInteractor
    private let router: IResetPasswordRouter

    private var email: String?

    init(interactor: IResetPasswordInteractor,
         router: IResetPasswordRouter,
         view: IResetPasswordView,
         email: String?) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.email = email
    }
}

// MARK: - IResetPasswordPresetner implementation

extension ResetPasswordPresenter: IResetPasswordPresenter {
    func handleSendButtonTapped(_ email: String?) {
        print(email)
        self.router.show(.newPassword)
    }

    func viewDidLoad() {
        self.view?.setupEmailText(self.email)
    }
}
