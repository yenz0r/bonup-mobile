//
//  LocaleManager.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 15.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

final class LocaleManager {

    enum Languages: String {

        case ru = "ru"
        case en = "en"
    }

    // MARK: - Initialization

    private init() { }

    // MARK: - Public variables

    static let shared = LocaleManager()

    var currentLocale: String {
        
        let langCode: String? = UserDefaultsManager.shared.getValue(key: .language)
        return langCode ?? (NSLocale.current.languageCode ?? "en")
    }

    var currentLanguage: Languages {

        return Languages(rawValue: self.currentLocale) ?? .en
    }

    let supportedLanguages: [Languages] = [.ru, .en]

    // MARK: - Public functions

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
    }
}
