//
//  SettingsParamsInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ISettingsParamsInteractor: AnyObject {

    func paramsList() -> [String]
    func selectedItem() -> Int
    func saveParam(at index: Int)
}

final class SettingsParamsInteractor {

    // MARK: - Private variables

    private let currentParamsType: SettingsParamsDependency.SettingsParamsType

    // MARK: - Init

    init(settingsParamsType: SettingsParamsDependency.SettingsParamsType) {

        self.currentParamsType = settingsParamsType
    }
}

// MARK: - ISettingsInteractor implementation

extension SettingsParamsInteractor: ISettingsParamsInteractor {

    func paramsList() -> [String] {

        switch self.currentParamsType {
        case .theme:
            return ThemeColorsManager.shared.supportedThemes.map { ThemeColorsManager.shared.titleForTheme($0) }

        case .lang:
            return LocaleManager.shared.supportedLanguages.map { LocaleManager.shared.titleForLanguage($0) }
        }
    }

    func selectedItem() -> Int {

        switch self.currentParamsType {
        case .theme:
            return ThemeColorsManager.shared.supportedThemes.lastIndex(of: ThemeColorsManager.shared.currentTheme) ?? 0

        case .lang:
            return LocaleManager.shared.supportedLanguages.lastIndex(of: LocaleManager.shared.currentLanguage) ?? 0
        }
    }

    func saveParam(at index: Int) {

        switch self.currentParamsType {
        case .theme:
            ThemeColorsManager.shared.setupCurrTheme(ThemeColorsManager.shared.supportedThemes[index])

        case .lang:
            LocaleManager.shared.setupCurrLang(LocaleManager.shared.supportedLanguages[index])
        }
    }
}
