//
//  UserDefaultsManager.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

final class UserDefaultsManager {

    enum UserDefaultsKeys: String {

        case language = "lang"
        case theme = "theme"
    }

    // MARK: - Static

    static let shared = UserDefaultsManager()

    // MARK: - Public

    func saveValue<T: Hashable>(_ value: T, key: UserDefaultsKeys) {

        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }

    func getValue<T>(key: UserDefaultsKeys) -> T? {
        
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }

    // MARK: - Initialization

    private init() { }
}
