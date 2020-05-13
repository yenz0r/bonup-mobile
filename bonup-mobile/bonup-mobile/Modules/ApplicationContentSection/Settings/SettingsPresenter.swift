//
//  SettingsPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ISettingsPresenter: AnyObject {

    func viewDidLoad()
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

    private weak var view: ISettingsView?
    private let interactor: ISettingsInteractor
    private let router: ISettingsRouter

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
                icon: AssetsHelper.shared.image(.eyeIcon)
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

        default:
            return
        }
    }

    func numberOfSettings() -> Int {
        return SettingsType.count
    }

    func viewDidLoad() {
        self.view?.setupHeader(
            with: AssetsHelper.shared.image(.profileUnselectedIcon),
            name: AccountManager.shared.currentUser?.name ?? "Name",
            email: AccountManager.shared.currentUser?.email ?? "Email"
        )
    }
}

