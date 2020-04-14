//
//  AuthVerificationInteractor.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IAuthVerificationInteractor: AnyObject {
    func verify(code: String, completion: ((Bool) -> Void)?)
    func resend()
}

final class AuthVerificationInteractor {

    // MARK: - Private variables

    private let networkProvider = MainNetworkProvider<EmailVerificationService>()

}

// MAKR: - IAuthVerificationInteractor implemenetation

extension AuthVerificationInteractor: IAuthVerificationInteractor {
    func verify(code: String, completion: ((Bool) -> Void)?) {

        let verifyParams = AuthVerificationParams(code: code)

        _ = networkProvider.requestString(
            .verify(params: verifyParams),
            completion: { token in
                //AccountManager.shared.currentToken = token
                completion?(true)
            },
            failure: { _ in
                completion?(false)
            }
        )
    }

    func resend() {
        _ = networkProvider.requestSignal(.resend)
    }
}
