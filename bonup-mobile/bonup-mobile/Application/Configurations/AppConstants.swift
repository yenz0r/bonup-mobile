//
//  AppConstants.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 15.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

var serverBase: String {
    let languageCode = LocaleManager.shared.currentLanguage.rawValue
    return "https://salty-plateau-70996.herokuapp.com/\(languageCode)"
}
