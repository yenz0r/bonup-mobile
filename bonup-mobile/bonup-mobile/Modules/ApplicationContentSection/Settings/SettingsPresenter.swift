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
        case profile = 0
        case changePassword
        case applicationTheme
        case applicationLanguage
        case categories
        case help
        case rateUs
        case logout

        static let count = 8
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
        case .profile:
            return SettingsPresentationModel(
                title: "Profile",
                isLogout: false,
                icon: AssetsHelper.shared.image(.profileUnselectedIcon)
            )
        case .changePassword:
            return SettingsPresentationModel(
                title: "Change password",
                isLogout: false,
                icon: AssetsHelper.shared.image(.profileUnselectedIcon)
            )
        case .applicationTheme:
            return SettingsPresentationModel(
                title: "Application theme",
                isLogout: false,
                icon: AssetsHelper.shared.image(.profileUnselectedIcon)
            )
        case .applicationLanguage:
            return SettingsPresentationModel(
                title: "Application language",
                isLogout: false,
                icon: AssetsHelper.shared.image(.profileUnselectedIcon)
            )
        case .categories:
            return SettingsPresentationModel(
                title: "Categories",
                isLogout: false,
                icon: AssetsHelper.shared.image(.profileUnselectedIcon)
            )
        case .help:
            return SettingsPresentationModel(
                title: "Help",
                isLogout: false,
                icon: AssetsHelper.shared.image(.profileUnselectedIcon)
            )
        case .rateUs:
            return SettingsPresentationModel(
                title: "Rate Us",
                isLogout: false,
                icon: AssetsHelper.shared.image(.profileUnselectedIcon)
            )
        case .logout:
            return SettingsPresentationModel(
                title: "Logout",
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

