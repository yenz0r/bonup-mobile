//
//  KeyChainService.swift
//  bonup-mobile
//
//  Created by yenz0redd on 15.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import KeychainSwift

final class KeyChainService {

    // MARK: - Keys

    enum StringKeys: String {
        case name = "kUserName"
        case email = "kUserEmail"
        case password = "kUserPassword"
    }

    enum BoolKeys: String {
        case isLogin = "kIsLogin"
    }

    // MARK: - Singletone

    static let shared = KeyChainService()

    private init() { }

    // MARK: - Private variables

    private let keyChain = KeychainSwift()

    // MARK: - Public functions

    func getString(for key: StringKeys) -> String? {
        return self.keyChain.get(key.rawValue)
    }

    func setString(_ value: String, for key: StringKeys) {
        self.keyChain.set(value, forKey: key.rawValue)
    }

    func getBool(for key: BoolKeys) -> Bool? {
        return self.keyChain.getBool(key.rawValue)
    }

    func setBool(_ value: Bool, for key: BoolKeys) {
        self.keyChain.set(value, forKey: key.rawValue)
    }
}
