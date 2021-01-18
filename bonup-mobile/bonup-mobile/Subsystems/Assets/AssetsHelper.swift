//
//  AssetsHelper.swift
//  bonup-mobile
//
//  Created by yenz0redd on 24.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class AssetsHelper {

    enum Images {
        case usernameIcon
        case passwordIcon
        case emailIcon
        case flagIcon
        case bonupLogo
        case codeLogo
        case emailLogo
        case passwordLogo
        case eyeIcon

        case organizationUnselectedIcon
        case profileUnselectedIcon
        case tasksUnselectedIcon
        case qrUnselectedIcon
        case actionsUnselectedIcon

        case organizationSelectedIcon
        case profileSelectedIcon
        case tasksSelectedIcon
        case qrSelectedIcon
        case actionsSelectedIcon

        case likeIcon
        case disslikeIcon
        case returnIcon
        case tasksListIcon
        case emptyTasksListIcon

        case settingsTheme
        case settingsLanguage
        case settingsPassword
        case settingsRateUs
        case settingsHelp
        case settingsCategory

        case activeCheckBox

        case addIcon
        case addImageIcon

        case minusIcon
        case plusIcon

        case juniorPacketIcon
        case middlePacketIcon
        case seniorPacketIcon
        case customPacketIcon
    }

    static let shared = AssetsHelper()

    private init() { }

    func image(_ type: Images) -> UIImage? {
        switch type {
        case .usernameIcon:
            return UIImage(named: "username-icon")
        case .passwordIcon:
            return UIImage(named: "password-icon")
        case .emailIcon:
            return UIImage(named: "email-icon")
        case .flagIcon:
            return UIImage(named: "flag-icon")
        case .bonupLogo:
            return UIImage(named: "bonup-image-logo")
        case .codeLogo:
            return UIImage(named: "code-logo")
        case .emailLogo:
            return UIImage(named: "email-logo")
        case .passwordLogo:
            return UIImage(named: "password-logo")
        case .eyeIcon:
            return UIImage(named: "eye-icon")

        case .actionsSelectedIcon:
            return UIImage(named: "actions-selected-icon")
        case .actionsUnselectedIcon:
            return UIImage(named: "actions-unselected-icon")
        case .profileSelectedIcon:
            return UIImage(named: "profile-selected-icon")
        case .profileUnselectedIcon:
            return UIImage(named: "profile-unselected-icon")
        case .organizationSelectedIcon:
            return UIImage(named: "orginization-selected-icon")
        case .organizationUnselectedIcon:
            return UIImage(named: "organization-unselected-icon")
        case .tasksSelectedIcon:
            return UIImage(named: "tasks-selected-icon")
        case .tasksUnselectedIcon:
            return UIImage(named: "tasks-unselected-icon")
        case .qrSelectedIcon:
            return UIImage(named: "qr-selected-icon")
        case .qrUnselectedIcon:
            return UIImage(named: "qr-unselected-icon")

        case .likeIcon:
            return UIImage(named: "like-icon")
        case .disslikeIcon:
            return UIImage(named: "disslike-icon")
        case .returnIcon:
            return UIImage(named: "return-icon")
        case .tasksListIcon:
            return UIImage(named: "task-list-navigation-icon")
        case .emptyTasksListIcon:
            return UIImage(named: "empty-tasks-list-icon")

        case .settingsHelp:
            return UIImage(named: "settings-help")!.withRenderingMode(.alwaysTemplate)
        case .settingsTheme:
            return UIImage(named: "settings-theme")!.withRenderingMode(.alwaysTemplate)
        case .settingsRateUs:
            return UIImage(named: "settings-rate-us")!.withRenderingMode(.alwaysTemplate)
        case .settingsCategory:
            return UIImage(named: "settings-category")!.withRenderingMode(.alwaysTemplate)
        case .settingsPassword:
            return UIImage(named: "settings-password")!.withRenderingMode(.alwaysTemplate)
        case .settingsLanguage:
            return UIImage(named: "settings-language")!.withRenderingMode(.alwaysTemplate)

        case .activeCheckBox:
            return UIImage(named: "active-check-box")!.withRenderingMode(.alwaysTemplate)

        case .addIcon:
            return UIImage(named: "add-icon")!.withRenderingMode(.alwaysTemplate)
        case .addImageIcon:
            return UIImage(named: "add-image-icon")!.withRenderingMode(.alwaysTemplate)

        case .plusIcon:
            return UIImage(named: "plus-icon")!.withRenderingMode(.alwaysTemplate)

        case .minusIcon:
            return UIImage(named: "minus-icon")!.withRenderingMode(.alwaysTemplate)

        case .juniorPacketIcon:
            return UIImage(named: "junior-packet-icon")

        case .middlePacketIcon:
            return UIImage(named: "middle-packet-icon")

        case .seniorPacketIcon:
            return UIImage(named: "senior-packet-icon")

        case .customPacketIcon:
            return UIImage(named: "custom-packet-icon")

        @unknown default:
            assertionFailure("Incorrect \(String(describing: self)) enum value")
        }
    }

}
