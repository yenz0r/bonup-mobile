//
//  SettingsParamsDependency.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

struct SettingsParamsDependency {

    enum SettingsParamsType {

        case theme, lang
    }

    let settingsParamsType: SettingsParamsType
    let parentNavigationController: UINavigationController
}
