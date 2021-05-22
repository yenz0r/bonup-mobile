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

    func loadAvatarId(withLoader: Bool,
                      success: ((String) -> Void)?,
                      failure: ((String) -> Void)?)

    func uploadAvatar(_ image: UIImage,
                      success: (() -> Void)?,
                      failure: ((String) -> Void)?)
}

final class SettingsInteractor {

    // MARK: - Services
    
    private let networkProvider = MainNetworkProvider<PhotosService>()
}

// MARK: - ISettingsInteractor implementation

extension SettingsInteractor: ISettingsInteractor {

    func uploadAvatar(_ image: UIImage,
                      success: (() -> Void)?,
                      failure: ((String) -> Void)?) {

        _ = networkProvider.request(
            .uploadPhoto(image),
            type: PhotoResponseEntity.self,
            completion: { [weak self] result in

                guard let token = AccountManager.shared.currentToken,
                      let self = self,
                      let id = Int(result.message) else { return }
                
                _ = self.networkProvider.request(
                    .sendPhotoId(token, id),
                    type: DefaultResponseEntity.self,
                    withLoader: true,
                    completion: { result in
                        
                        success?()
                    },
                    failure: { err in
                        
                        failure?(err?.localizedDescription ?? "")
                    })
            },
            failure: { err in

                failure?(err?.localizedDescription ?? "")
            }
        )
    }

    
    func loadAvatarId(withLoader: Bool,
                      success: ((String) -> Void)?,
                      failure: ((String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { failure?("ui_error_title".localized); return }
        
        _ = networkProvider.request(
            .getPhotoId(token),
            type: PhotoResponseEntity.self,
            withLoader: withLoader,
            completion: { result in

                if result.isSuccess {

                    success?(result.message)
                } else {

                    failure?(result.message)
                }
            },
            failure: { err in

                failure?(err?.localizedDescription ?? "ui_error_title".localized)
            }
        )
    }

    func logout() {

        AccountManager.shared.resetAuthCredentials()
    }
}
