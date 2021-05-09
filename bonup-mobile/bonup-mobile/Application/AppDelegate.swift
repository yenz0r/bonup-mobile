//
//  AppDelegate.swift
//  bonup-mobile
//
//  Created by yenz0redd on 08.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // setup app window
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // setup services
        self.setupGoogleServices()
        self.setupYandexServices()

        // setup theme
        ThemeColorsManager.shared.start()

        // setup localization
        LocaleManager.shared.start()

        // setup keyboard handler
        IQKeyboardManager.shared.enable = true

        // setup app router
        AppRouter.shared.appWindow = self.window

        // start application
        if AccountManager.shared.isLogined() {
            AppRouter.shared.present(.openApplication)
        } else {
            AppRouter.shared.present(.login(name: nil, email: nil))
        }

        return true
    }
}

