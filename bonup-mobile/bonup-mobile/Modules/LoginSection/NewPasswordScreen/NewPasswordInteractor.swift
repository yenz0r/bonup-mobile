//
//  NewPasswordInteractor.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol INewPasswordInteractor {
    func setupNewPasswordRequest(_ newPassword: String, completion: ((Bool) -> Void)?)
}

final class NewPasswordInteractor {

    // MARK: - Private variables

    private let networkProvider = MainNetworkProvider<NewPasswordService>()

}

// MARK: - INewPasswordInteractor implementation

extension NewPasswordInteractor: INewPasswordInteractor {

    func setupNewPasswordRequest(_ newPassword: String, completion: ((Bool) -> Void)?) {

        let newPasswordParams = NewPasswordParams(newPassword: newPassword)

        // should return model with token to protect from hacking pass
        // and continue app work with new token
        
        _ = networkProvider.requestBool(
            .setupNewPassword(params: newPasswordParams),
            completion: { resultBool in
                completion?(true)
            },
            failure: { _ in
                completion?(false)
            }
        )

    }

}
