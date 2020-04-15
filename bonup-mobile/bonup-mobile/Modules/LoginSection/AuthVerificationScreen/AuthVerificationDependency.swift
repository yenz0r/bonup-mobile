//
//  AuthVerificationDependency.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

struct AuthVerificationDependency {

    enum AuthVerificationUsageType {
        case resetPassword
        case registration
    }

    let parentViewController: UIViewController
    let usageType: AuthVerificationUsageType
}
