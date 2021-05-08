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
        AppRouter.shared.present(.openApplication)
//        if AccountManager.shared.isLogined() {
//            AppRouter.shared.present(.openApplication)
//        } else {
//            AppRouter.shared.present(.login(name: nil, email: nil))
//        }

        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "bonup_mobile")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

