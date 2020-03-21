//
//  AppDelegate+Configurations.swift
//  bonup-mobile
//
//  Created by yenz0redd on 08.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import Firebase

#if RELEASE_FREE || DEBUG_FREE
let APP_IS_FREE_VERSION = true
#else
let APP_IS_FREE_VERSION = false
#endif

#if RELEASE_FREE || RELEASE_PAID
let APP_IS_RELEASE_VERSION = true
#else
let APP_IS_RELEASE_VERSION = false
#endif

// MARK: - Google services setup

extension AppDelegate {

    func setupGoogleServices() {
        FirebaseApp.configure()

        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            Crashlytics.crashlytics().setUserID(uuid)
        }
    }

}
