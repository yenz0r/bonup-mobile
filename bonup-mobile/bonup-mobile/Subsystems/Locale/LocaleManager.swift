//
//  LocaleManager.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 15.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

final class LocaleManager {

    enum Languages: String, CaseIterable {

        case ru = "ru"
        case en = "en"
    }

    // MARK: - Initialization

    private init() { }

    // MARK: - Static variables

    static let shared = LocaleManager()

    // MARK: - Public variables

    let notificationName = NSNotification.Name(rawValue: "localizationChanged")

    var currentLocale: String {
        
        let langCode: String? = UserDefaultsManager.shared.getValue(key: .language)
        return langCode ?? (NSLocale.current.languageCode ?? "en")
    }

    var currentLanguage: Languages {

        return Languages(rawValue: self.currentLocale) ?? .en
    }

    let supportedLanguages = Languages.allCases

    // MARK: - Public functions

    func start() {

        self.setupCurrLang(self.currentLanguage)
    }

    func titleForLanguage(_ lang: Languages) -> String {

        switch lang {
        case .ru:
            return "Русский"

        case .en:
            return "English"
        }
    }

    func setupCurrLang(_ lang: Languages) {

        UserDefaultsManager.shared.saveValue(lang.rawValue, key: .language)

        Bundle.set(language: lang.rawValue)

        NotificationCenter.default.post(name: self.notificationName, object: nil, userInfo: nil)
    }
}
