//
//  ChangePasswordInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IChangePasswordInteractor: AnyObject {
    func requestUpdatePassword(newPassword: String,
                               success: (() -> Void)?,
                               failure: ((String) -> Void)?)
}

final class ChangePasswordInteractor {

    private let networkProvider = MainNetworkProvider<NewPasswordService>()

}

// MARK: - IChangePasswordInteractor implementation

extension ChangePasswordInteractor: IChangePasswordInteractor {

    func requestUpdatePassword(newPassword: String,
                               success: (() -> Void)?,
                               failure: ((String) -> Void)?) {
        let params = NewPasswordParams(newPassword: newPassword)
        _ = self.networkProvider.requestBool(
            .setupNewPassword(params: params),
            completion: { result in
                if result {
                    success?()
                } else {
                    failure?("".localized)
                }
            },
            failure: { err in
                failure?(err?.localizedDescription ?? "")
            }
        )
    }

}
