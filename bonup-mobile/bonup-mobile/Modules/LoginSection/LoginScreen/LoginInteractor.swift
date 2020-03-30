//
//  LoginInteractor.swift
//  bonup-mobile
//
//  Created by yenz0redd on 14.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ILoginInteractor {
    func handleLoginRequest(for type: LoginInteractor.LoginRequest,
                            with authParams: AuthParams,
                            completion: ((Bool) -> Void)?)
}

final class LoginInteractor {
    enum LoginRequest {
        case auth, register
    }

    private let networkProvider = MainNetworkProvider<AuthService>()
}

// MARK: - ILoginInteractor

extension LoginInteractor: ILoginInteractor {
     func handleLoginRequest(for type: LoginInteractor.LoginRequest,
                                with authParams: AuthParams,
                                completion: ((Bool) -> Void)?) {
        var target: AuthService

        switch type {
        case .auth:
            target = .auth(params: authParams)
        case .register:
            target = .register(params: authParams)
        }

        _ = networkProvider.requestString(
            target,
            completion: { token in
                //AccountManager.shared.currentToken = token
                completion?(true)
            },
            failure: { _ in
                completion?(false)
            }
        )
    }
}
