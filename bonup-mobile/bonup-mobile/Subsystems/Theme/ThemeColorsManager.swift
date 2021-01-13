//
//  ThemeColorsManager.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

final class ThemeColorsManager {

    enum Themes: Int {

        case light = 0
        case dark
    }

    // MARK: - Static

    static let shared = ThemeColorsManager()

    // MARK: - Init

    private init() { }

    // MARK: - Public variables

    let supportedThemes: [Themes] = [.light, .dark]

    var currentTheme: Themes {

        if let theme: Int = UserDefaultsManager.shared.getValue(key: .theme) {

            return Themes(rawValue: theme) ?? .light
        }
        else {

            return .light
        }
    }

    // MARK: - Public functions

    func setupCurrTheme(_ theme: Themes) {

        UserDefaultsManager.shared.saveValue(theme.rawValue, key: .theme)
    }

    func titleForTheme(_ theme: Themes) -> String {

        switch theme {
        case .light:
            return "ui_light".localized

        case .dark:
            return "ui_dark".localized
        }
    }
}
