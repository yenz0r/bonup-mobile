//
//  ProfileInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 20.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IProfileInteractor: AnyObject {

    func getUserInfo(success: ((ProfileResponseDetailsEntity) -> Void)?, failure: ((String) -> Void)?)
}

final class ProfileInteractor {

    private let networkProvider = MainNetworkProvider<ProfileService>()

}

// MARK: - IChangePasswordInteractor implementation

extension ProfileInteractor: IProfileInteractor {

    func getUserInfo(success: ((ProfileResponseDetailsEntity) -> Void)?, failure: ((String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.request(
            .getUsetData(token),
            type: ProfileResponseEntity.self,
            completion: { result in
                if result.isSuccess {

                    success?(result.userInfo)
                } else {

                    //failure?(result.message)
                }
            },
            failure: { err in
                
                failure?(err?.localizedDescription ?? "")
            }
        )
    }
}
