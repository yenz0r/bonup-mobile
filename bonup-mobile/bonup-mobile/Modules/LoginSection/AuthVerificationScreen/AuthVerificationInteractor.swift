//
//  AuthVerificationInteractor.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IAuthVerificationInteractor: AnyObject {
    func verify(code: String, completion: ((Bool, String) -> Void)?)
    func resend()
}

final class AuthVerificationInteractor {

    // MARK: - Private variables

    private let networkProvider = MainNetworkProvider<EmailVerificationService>()

}

// MAKR: - IAuthVerificationInteractor implemenetation

extension AuthVerificationInteractor: IAuthVerificationInteractor {
    func verify(code: String, completion: ((Bool, String) -> Void)?) {

        let verifyParams = EmailVerificationParams(code: code)

        _ = networkProvider.request(
            .verify(params: verifyParams),
            type: EmailVerificationResponseEntity.self,
            completion: { response in
                
                if response.isSuccess {
                    AccountManager.shared.saveToken(response.token)
                    completion?(true, "")
                } else {
                    completion?(false, response.message)
                }
            },
            failure: { err in

                completion?(false, err?.localizedDescription ?? "ui_incorrect_verification_description".localized)
            }
        )
    }

    func resend() {
        _ = networkProvider.requestSignal(.resend)
    }
}
