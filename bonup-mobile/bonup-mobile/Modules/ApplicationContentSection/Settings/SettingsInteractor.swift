//
//  SettingsInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ISettingsInteractor: AnyObject {

    func logout()

    func loadAvatar(withLoader: Bool,
                    success: ((UIImage?) -> Void)?,
                    failure: ((String) -> Void)?)

    func uploadAvatar(_ image: UIImage,
                      success: (() -> Void)?,
                      failure: ((String) -> Void)?)
}

final class SettingsInteractor {

    private let networkProvider = MainNetworkProvider<PhotosService>()

}

// MARK: - ISettingsInteractor implementation

extension SettingsInteractor: ISettingsInteractor {

    func uploadAvatar(_ image: UIImage,
                      success: (() -> Void)?,
                      failure: ((String) -> Void)?) {

        _ = networkProvider.request(
            .uploadPhoto(image),
            type: ProfileResponseEntity.self,
            completion: { result in

                if result.isSuccess {

                    success?()
                } else {

                    failure?(result.message)
                }
            },
            failure: { err in

                failure?(err?.localizedDescription ?? "")
            }
        )
    }

    
    func loadAvatar(withLoader: Bool,
                    success: ((UIImage?) -> Void)?,
                    failure: ((String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }
        
        _ = networkProvider.requestImage(
            .getPhoto(token),
            withLoader: withLoader,
            completion: { image in

                success?(image)
            },
            failure: { err in

                failure?(err?.localizedDescription ?? "")
            }
        )
    }

    func logout() {

        AccountManager.shared.resetAuthCredentials()
    }
}
