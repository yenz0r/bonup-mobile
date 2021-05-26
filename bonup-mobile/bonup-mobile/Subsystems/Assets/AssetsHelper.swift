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
        
        case userLocationMapIcon
        case companyLocationMapIcon
        
        case rightArrow
        
        case vkIcon, webIcon, phoneIcon
        
        case alertHelpIcon
        
        case filmsSectionIcon
        case literatureSectionIcon
        case coffeeSectionIcon
        case healthSectionIcon
        case mediaSectionIcon
        case musicSectionIcon
        case servicesSectionIcon
        case foodSectionIcon
        case sportSectionIcon
        
        case addCouponIcon
        case addStockIcon
        case modifyIcon
        case settingsIcon
        case userProfileIcon
        case statisticsIcon
        case checkTaskIcon
        case verifyCouponIcon
        case addTaskIcon
        
        case userProfileSelectedIcon
        case userProfileUnselectedIcon
        case userSettingsSelectedIcon
        case userSettingsUnselectedIcon
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
            
        case .userLocationMapIcon:
            return UIImage(named: "user-location-map-icon")
            
        case .companyLocationMapIcon:
            return UIImage(named: "company-location-map-icon")
            
        case .rightArrow:
            return UIImage(named: "right-arrow")
            
        case .vkIcon:
            return UIImage(named: "vk-icon")
        case .webIcon:
            return UIImage(named: "web-icon")
        case .phoneIcon:
            return UIImage(named: "phone-icon")
            
        case .alertHelpIcon:
            return UIImage(named: "alert-help-icon")
        case .filmsSectionIcon:
            return UIImage(named: "films-section-icon")
        case .literatureSectionIcon:
            return UIImage(named: "literature-section-icon")
        case .coffeeSectionIcon:
            return UIImage(named: "coffee-section-icon")
        case .healthSectionIcon:
            return UIImage(named: "health-section-icon")
        case .mediaSectionIcon:
            return UIImage(named: "media-section-icon")
        case .musicSectionIcon:
            return UIImage(named: "music-section-icon")
        case .servicesSectionIcon:
            return UIImage(named: "services-section-icon")
        case .foodSectionIcon:
            return UIImage(named: "food-section-icon")
        case .sportSectionIcon:
            return UIImage(named: "sport-section-icon")
            
        case .addCouponIcon:
            return UIImage(named: "add-coupon-icon")
        case .addStockIcon:
            return UIImage(named: "add-stock-icon")
        case .modifyIcon:
            return UIImage(named: "modify-icon")
        case .settingsIcon:
            return UIImage(named: "settings-icon")
        case .userProfileIcon:
            return UIImage(named: "user-profile-icon")
        case .statisticsIcon:
            return UIImage(named: "statistics-icon")
        case .checkTaskIcon:
            return UIImage(named: "check-task-icon")
        case .verifyCouponIcon:
            return UIImage(named: "verify-coupon-icon")
        case .addTaskIcon:
            return UIImage(named: "add-task-icon")
        case .userProfileSelectedIcon:
            return UIImage(named: "user-profile-selected-icon")
        case .userProfileUnselectedIcon:
            return UIImage(named: "user-profile-unselected-icon")
        case .userSettingsSelectedIcon:
            return UIImage(named: "user-settings-selected-icon")
        case .userSettingsUnselectedIcon:
            return UIImage(named: "user-settings-unselected-icon")
            
        @unknown default:
            assertionFailure("Incorrect \(String(describing: self)) enum value")
        }
    }

}
