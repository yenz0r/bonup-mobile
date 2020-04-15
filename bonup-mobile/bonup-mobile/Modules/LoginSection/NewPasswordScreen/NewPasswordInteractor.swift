//
//  NewPasswordInteractor.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol INewPasswordInteractor {
    func setupNewPasswordRequest(_ newPassword: String, completion: ((Bool, String) -> Void)?)
}

final class NewPasswordInteractor {

    // MARK: - Private variables

    private let networkProvider = MainNetworkProvider<NewPasswordService>()

}

// MARK: - INewPasswordInteractor implementation

extension NewPasswordInteractor: INewPasswordInteractor {

    func setupNewPasswordRequest(_ newPassword: String, completion: ((Bool, String) -> Void)?) {

        let newPasswordParams = NewPasswordParams(newPassword: newPassword)

        // should return model with token to protect from hacking pass
        // and continue app work with new token

        _ = networkProvider.request(
            .setupNewPassword(params: newPasswordParams),
            type: NewPasswordResponseEntity.self,
            completion: { response in
                if response.isSuccess {
                    AccountManager.shared.saveToken(response.newToken)
                    completion?(true, "")
                } else {
                    completion?(false, response.message)
                }
            },
            failure: { err in
                completion?(false, err?.localizedDescription ?? "")
            }
        )
    }

}
