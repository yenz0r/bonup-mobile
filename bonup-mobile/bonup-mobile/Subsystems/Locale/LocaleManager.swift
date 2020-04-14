//
//  LocaleManager.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 15.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

final class LocaleManager {

    // MARK: - Public variables

    static let shared = LocaleManager()

    var currentLocale: String {
        return NSLocale.current.languageCode ?? "en"
    }

    // MARK: - Initialization

    private init() { }

}
