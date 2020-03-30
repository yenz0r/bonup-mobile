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

        _ = self.networkProvider.requestBool(
            .askResetCode(params: params),
            completion: { resultBool in
                completion?(resultBool)
            },
            failure: { _ in
                completion?(false)
            }
        )
    }

}
