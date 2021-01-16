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

    func viewDidLoad()
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

    func viewDidLoad() {

        let name = AccountManager.shared.currentUser?.name ?? "Your Name"
        let email = AccountManager.shared.currentUser?.email ?? "your.email@email.com"

        self.interactor.loadAvatar { [weak self] image in

            DispatchQueue.main.async {

                self?.view?.setupHeader(
                    with: image ?? AssetsHelper.shared.image(.profileUnselectedIcon),
                    name: name,
                    email: email
                )
            }
        } failure: { [weak self] message in

            DispatchQueue.main.async {

//                self?.router.show(.showErrorAlert(message))

                self?.view?.setupHeader(
                    with: AssetsHelper.shared.image(.profileUnselectedIcon),
                    name: name,
                    email: email
                )
            }
        }
    }

    func handleAvatarIconTap() {

        var config = FMPhotoPickerConfig()
        config.mediaTypes = [.image]
        config.selectMode = .single
        config.maxImage = 1
        config.maxVideo = 0
        config.useCropFirst = true
        config.strings = [

            "picker_button_cancel":                     "ui_cancel".localized,
            "picker_button_select_done":                "ui_done_title".localized,
            "picker_warning_over_image_select_format":  "",
            "picker_warning_over_video_select_format":  "",

            "present_title_photo_created_date_format":  "yyyy/M/d",
            "present_button_back":                      "",
            "present_button_edit_image":                "ui_edit".localized,

            "editor_button_cancel":                     "ui_cancel".localized,
            "editor_button_done":                       "ui_done_title".localized,
            "editor_menu_filter":                       "ui_filter".localized,
            "editor_menu_crop":                         "ui_crop".localized,
            "editor_menu_crop_button_reset":            "ui_reset".localized,
            "editor_menu_crop_button_rotate":           "ui_rotate".localized,

            "editor_crop_ratio4x3":                     "4:3",
            "editor_crop_ratio16x9":                    "16:9",
            "editor_crop_ratio9x16":                    "9x16",
            "editor_crop_ratioCustom":                  "ui_custom".localized,
            "editor_crop_ratioOrigin":                  "ui_origin".localized,
            "editor_crop_ratioSquare":                  "ui_square".localized,

            "permission_dialog_title":                  "ui_select_photo_title".localized,
            "permission_dialog_message":                "ui_select_photo_description".localized,
            "permission_button_ok":                     "ui_done_title".localized,
            "permission_button_cancel":                 "ui_cancel".localized
        ]

        self.router.show(.avatarSelection(self, config))
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
