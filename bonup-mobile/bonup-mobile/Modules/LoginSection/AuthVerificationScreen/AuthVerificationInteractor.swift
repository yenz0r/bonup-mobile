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

    private lazy var networkProvider = MainNetworkProvider<EmailVerificationService>()
    private lazy var storageProvider = DataBaseProvider().authorizationProvider

}

// MAKR: - IAuthVerificationInteractor implemenetation

extension AuthVerificationInteractor: IAuthVerificationInteractor {
    func verify(code: String, completion: ((Bool, String) -> Void)?) {

        let verifyParams = EmailVerificationParams(code: code)

        _ = networkProvider.request(
            .verify(params: verifyParams),
            type: EmailVerificationResponseEntity.self,
            completion: { [weak self] response in
                
                if response.isSuccess {
                    
                    AccountManager.shared.saveToken(response.token)
                    
                    if let user = AccountManager.shared.currentUser,
                       let name = user.name,
                       let email = user.email {
                        
                        self?.storeCreds(name: name, email: email, completion: {
                                
                            completion?(true, "")
                        })
                    }
                    else {
                        
                        completion?(true, "")
                    }
                    
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
