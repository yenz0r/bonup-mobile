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
        @unknown default:
            assertionFailure("Incorrect \(String(describing: self)) enum value")
        }
    }

}
