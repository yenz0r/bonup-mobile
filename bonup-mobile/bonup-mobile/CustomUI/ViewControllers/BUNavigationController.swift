//
//  BUNavigationController.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import SwiftTheme

final class BUNavigationController: UINavigationController {

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true

        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backItem.tintColor = UIColor.red.withAlphaComponent(0.7)
        self.navigationItem.backBarButtonItem = backItem

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeChanged(_:)),
                                               name: ThemeColorsManager.shared.notificationName,
                                               object: nil)

        self.themeChanged(Notification(name: ThemeColorsManager.shared.notificationName))
    }

    // MARK: - Public Functions

    func setupTabBarItem(with title: String,
                      unselectedImage: UIImage?,
                      selectedImage: UIImage?) {
        self.tabBarItem = UITabBarItem(
            title: title,
            image: unselectedImage,
            selectedImage: selectedImage
        )
    }

    // MARK: - Selectors

    @objc private func themeChanged(_ notification: Notification) {

        var theme: ThemeColorsManager.Themes

        if let new = notification.userInfo?["theme"] as? ThemeColorsManager.Themes {

            theme = new
        }
        else {

            theme = ThemeColorsManager.shared.currentTheme
        }

        var titleColor: UIColor

        switch theme {
        case .light:
            titleColor = .black

        case .dark:
            titleColor = .white
        }

        let textAttributes = [
            NSAttributedString.Key.font: UIFont.avenirRoman(20.0),
            NSAttributedString.Key.foregroundColor: titleColor
        ]
        self.navigationBar.titleTextAttributes = textAttributes
    }
}
