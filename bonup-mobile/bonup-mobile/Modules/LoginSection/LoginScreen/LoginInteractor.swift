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
                            completion: ((Bool, String) -> Void)?)
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
                            completion: ((Bool, String) -> Void)?) {
        var target: AuthService

        switch type {
        case .auth:
            target = .auth(params: authParams)
        case .register:
            target = .register(params: authParams)
        }

        _ = networkProvider.request(
            target,
            type: AuthResponseEntity.self,
            completion: { entity in
                if entity.isSuccess {
                    if type == .auth {
                        AccountManager.shared.saveToken(entity.message)
                    }
                    completion?(entity.isSuccess, "")
                } else {
                    completion?(entity.isSuccess, entity.message)
                }
            },
            failure: { err in
                completion?(false, err?.localizedDescription ?? "ui_alert_incorrect_auth_params".localized)
            }
        )
    }
}
