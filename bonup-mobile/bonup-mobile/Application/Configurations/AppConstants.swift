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
    return "http://ec2-18-116-29-163.us-east-2.compute.amazonaws.com:5000/\(languageCode)"
}

let GOOGLE_AD_KEY = "ca-app-pub-4243143975731364/2569848784"
let GOOGLE_AD_PHONE_KEY = "32cfb0ebd92f60909f3ddce2fbff5989"

let YANDEX_MAPS_KEY = "fb558813-f86a-45ed-aa70-f651e3769ca1"

// MARK: - UI

let SCREEN_WIDTH = UIScreen.main.bounds.width
