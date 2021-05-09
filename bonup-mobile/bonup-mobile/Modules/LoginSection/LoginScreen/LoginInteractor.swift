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

    private lazy var networkProvider = MainNetworkProvider<AuthService>()
    private lazy var storageProvider = DataBaseProvider().authorizationProvider
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
            completion: { [weak self] entity in
                if entity.isSuccess {

                    AccountManager.shared.currentUser = User(
                        name: authParams.name,
                        email: authParams.email,
                        password: authParams.password
                    )

                    if type == .auth {

                        AccountManager.shared.saveToken(entity.message)

                        self?.storeCreds(name: authParams.name,
                                         email: authParams.email,
                                         completion: {

                                            completion?(entity.isSuccess, "")
                                         })
                    }
                    else {

                        completion?(entity.isSuccess, "")
                    }
                } else {
                    completion?(entity.isSuccess, entity.message)
                }
            },
            failure: { err in
                completion?(false, err?.localizedDescription ?? "ui_alert_incorrect_auth_params".localized)
            }
        )
    }
    
    private func storeCreds(name: String, email: String, completion: @escaping () -> Void) {
        
        self.storageProvider.read(type: AuthCredRealmObject.self,
                                  completion: { [weak self] realm, results in
                                    
                                    if let resolvedResults = realm?.resolve(results) {
                                        
                                        let accountsCreds = resolvedResults
                                            .compactMap { $0 as? AuthCredRealmObject }
                                            .first(where:  { $0.email == email })
                                        
                                        if accountsCreds == nil {
                                            
                                            let creds = AuthCredRealmObject()
                                            creds.name = name
                                            creds.email = email
                                            
                                            self?.storageProvider.write(element: creds,
                                                                        failure: nil)
                                        }
                                    }
                                    
                                    completion()
                                  },
                                  failure: { error in
                                    
                                    completion()
                                  })
    }
}
