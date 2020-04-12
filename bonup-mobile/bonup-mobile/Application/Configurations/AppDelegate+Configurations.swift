//
//  AppDelegate+Configurations.swift
//  bonup-mobile
//
//  Created by yenz0redd on 08.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import Firebase

#if RELEASE_FREE
let IS_RELEASE_FREE = true
#else
let IS_RELEASE_FREE = false
#endif

#if RELEASE_PAID
let IS_RELEASE_PAID = true
#else
let IS_RELEASE_PAID = false
#endif

#if DEBUG_FREE
let IS_DEBUG_FREE = true
#else
let IS_DEBUG_FREE = false
#endif

#if DEBUG_PAID
let IS_DEBUG_PAID = true
#else
let IS_DEBUG_PAID = false
#endif

#if (RELEASE_FREE || RELEASE_PAID)
let APP_IS_RELEASE_VERSION = true
#else
let APP_IS_RELEASE_VERSION = false
#endif

// MARK: - Google services setup

extension AppDelegate {

    func setupGoogleServices() {
        #if (DEBUG_FREE || DEBUG_PAID)
print("debug")
        #else
print("release")
        #endif

        print("isdebugpaid \(IS_DEBUG_PAID)")
        

        var optionsPath: String?
        return
//        if APP_IS_FREE_VERSION && APP_IS_RELEASE_VERSION {
//            optionsPath = Bundle.main.path(forResource: "GoogleService-Realese-Free", ofType: "plist")
//        } else if APP_IS_FREE_VERSION && !APP_IS_RELEASE_VERSION {
//            optionsPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
//        }

        if
            let optionsPath = optionsPath,
            let options = FirebaseOptions(contentsOfFile: optionsPath) {
            FirebaseApp.configure(options: options)
        } else {
            return
        }

        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            Crashlytics.crashlytics().setUserID(uuid)
        }
    }

}
