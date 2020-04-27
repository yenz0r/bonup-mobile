//
//  BenefitsInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IBenefitsInteractor: AnyObject {
}

final class BenefitsInteractor {

    private let networkProvider = MainNetworkProvider<NewPasswordService>()

}

// MARK: - IChangePasswordInteractor implementation

extension BenefitsInteractor: IBenefitsInteractor {
}
