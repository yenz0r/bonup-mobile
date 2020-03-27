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
        @unknown default:
            assertionFailure("Incorrect \(String(describing: self)) enum value")
        }
    }

}
