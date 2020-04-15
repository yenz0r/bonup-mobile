//
//  AccountManager.swift
//  bonup-mobile
//
//  Created by yenz0redd on 15.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

final class AccountManager {

    // MARK: - Singltone

    static let shared = AccountManager()

    private init() { }

    // MARK: - Private variables

    private let keyChainService = KeyChainService.shared

    // MARK: - Public variables

    var currentUser: User?
    private(set) var currentToken: String?

    // MARK: - Public function

    func saveToken(_ token: String?) {
        if let token = token {
            self.currentToken = token
            self.keyChainService.setString(token, for: .authToken)
        } else {
            self.keyChainService.setString("", for: .authToken)
        }
    }

    func saveAuthCredentials(name: String?, email: String?, password: String?) {
        guard
            let name = name,
            let email = email,
            let password = password
        else { return }

        self.keyChainService.setString(name, for: .name)
        self.keyChainService.setString(password, for: .password)
        self.keyChainService.setString(email, for: .email)
    }

    func resetAuthCredentials() {
        self.keyChainService.setString("", for: .name)
        self.keyChainService.setString("", for: .password)
        self.keyChainService.setString("", for: .email)
    }

    func isLogined() -> Bool {
        guard let authToken = self.keyChainService.getString(for: .authToken) else { return false }
        return authToken != ""
    }

}
