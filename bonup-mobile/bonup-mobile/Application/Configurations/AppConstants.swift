//
//  AppConstants.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 15.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

// MARK: - Keys

var SERVER_BASE_URL: String {
    
    let languageCode = LocaleManager.shared.currentLanguage.rawValue
    return "https://salty-plateau-70996.herokuapp.com/\(languageCode)"
}

let GOOGLE_AD_KEY = "ca-app-pub-4243143975731364/2569848784"

let YANDEX_MAPS_KEY = "fb558813-f86a-45ed-aa70-f651e3769ca1"

// MARK: - UI

let SCREEN_WIDTH = UIScreen.main.bounds.width
