//
//  SettingsInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ISettingsInteractor: AnyObject {

    func logout()
}

final class SettingsInteractor {

    private let networkProvider = MainNetworkProvider<NewPasswordService>()

}

// MARK: - ISettingsInteractor implementation

extension SettingsInteractor: ISettingsInteractor {

    func logout() {

        AccountManager.shared.resetAuthCredentials()
    }
}
