//
//  SettingsPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import FMPhotoPicker

protocol ISettingsPresenter: AnyObject {

    func refreshData()
    func handleAvatarIconTap()

    func numberOfSettings() -> Int
    func presentationModel(for type: SettingsPresenter.SettingsType) -> SettingsPresentationModel
    func handleDidSelectSetting(for type: SettingsPresenter.SettingsType)
}

final class SettingsPresenter {
    
    enum SettingsType: Int {
        
        case changePassword = 0
        case applicationTheme
        case applicationLanguage
        case categories
        case help
        case rateUs
        case logout

        static let count = 7
    }
    
    // MARK: - Private variables

    private weak var view: ISettingsView?
    private let interactor: ISettingsInteractor
    private let router: ISettingsRouter
    
    // MARK: - State variables
    
    private var isFirstRefresh = true

    // MARK: - Init
    
    init(view: ISettingsView?, interactor: ISettingsInteractor, router: ISettingsRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskSelectionPresenter implementation

extension SettingsPresenter: ISettingsPresenter {

    func presentationModel(for type: SettingsPresenter.SettingsType) -> SettingsPresentationModel {
        switch type {
        case .changePassword:
            return SettingsPresentationModel(
                title: "ui_change_password_title".localized,
                isLogout: false,
                icon: AssetsHelper.shared.image(.settingsPassword)
            )
        case .applicationTheme:
            return SettingsPresentationModel(
                title: "ui_application_theme_title".localized,
                isLogout: false,
                icon: AssetsHelper.shared.image(.settingsTheme)
            )
        case .applicationLanguage:
            return SettingsPresentationModel(
                title: "ui_application_language_title".localized,
                isLogout: false,
                icon: AssetsHelper.shared.image(.settingsLanguage)
            )
        case .categories:
            return SettingsPresentationModel(
                title: "ui_categories_title".localized,
                isLogout: false,
                icon: AssetsHelper.shared.image(.settingsCategory)
            )
        case .help:
            return SettingsPresentationModel(
                title: "ui_help_title".localized,
                isLogout: false,
                icon: AssetsHelper.shared.image(.settingsHelp)
            )
        case .rateUs:
            return SettingsPresentationModel(
                title: "ui_rate_us_title".localized,
                isLogout: false,
                icon: AssetsHelper.shared.image(.settingsRateUs)
            )
        case .logout:
            return SettingsPresentationModel(
                title: "ui_logout_title".localized,
                isLogout: true,
                icon: nil
            )
        }
    }

    func handleDidSelectSetting(for type: SettingsType) {
        switch type {
        case .changePassword:
            self.router.show(.changePassword)

        case .logout:
            self.interactor.logout()
            self.router.show(.logout)

        case .categories:
            self.router.show(.categories)

        case .rateUs:
            self.router.show(.rateUs)

        case .help:
            self.router.show(.help)

        case .applicationLanguage:
            self.router.show(.params(.lang))

        case .applicationTheme:
            self.router.show(.params(.theme))
        }
    }

    func numberOfSettings() -> Int {
        return SettingsType.count
    }

    func refreshData() {

        if self.isFirstRefresh {
            
            self.isFirstRefresh.toggle()
        }
        
        let name = AccountManager.shared.currentUser?.name ?? "Your Name"
        let email = AccountManager.shared.currentUser?.email ?? "your.email@email.com"

        self.interactor.loadAvatar(withLoader: self.isFirstRefresh) { [weak self] image in

            DispatchQueue.main.async {

                self?.view?.setupHeader(
                    with: image ?? AssetsHelper.shared.image(.addImageIcon),
                    name: name,
                    email: email
                )
            }
        } failure: { [weak self] message in

            DispatchQueue.main.async {

                self?.router.show(.showErrorAlert(message))

                self?.view?.setupHeader(
                    with: AssetsHelper.shared.image(.addImageIcon),
                    name: name,
                    email: email
                )
            }
        }
    }

    func handleAvatarIconTap() {

        self.router.show(.avatarSelection(self))
    }
}

extension SettingsPresenter: FMPhotoPickerViewControllerDelegate {

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {

        guard let icon = photos.first else {

            self.view?.updateAvatarIcon(nil)
            return
        }

        self.interactor.uploadAvatar(icon) { [weak self] in

            DispatchQueue.main.async {

                self?.view?.updateAvatarIcon(icon)
            }
        }
        failure: { [weak self] errMessage in

            DispatchQueue.main.async {

                self?.view?.updateAvatarIcon(nil)
                self?.router.show(.showErrorAlert(errMessage))
            }
        }
    }
}
