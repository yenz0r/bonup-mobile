//
//  ResetPasswordInteractor.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IResetPasswordInteractor {
    func askResetCodeRequest(for email: String, completion: ((Bool) -> Void)?)
}

final class ResetPasswordInteractor {

    private let networkProvider = MainNetworkProvider<ResetPasswordService>()

}

// MARK: - IResetPasswordInteractor implementation

extension ResetPasswordInteractor: IResetPasswordInteractor {

    func askResetCodeRequest(for email: String, completion: ((Bool) -> Void)?) {

        let params = ResetPasswordParams(email: email)

        _ = self.networkProvider.request(
            .askResetCode(params: params),
            type: ResetPasswordResponseEntity.self,
            completion: { result in

                if result.isSuccess {
                    AccountManager.shared.currentUser = User(name: "", email: email, password: "")
                }

                completion?(result.isSuccess)
            },
            failure: { _ in

                completion?(false)
            }
        )
    }

}
