//
//  BenefitsInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IBenefitsInteractor: AnyObject {

    func getBenefits(success:((BenefitsResponseEntity) -> Void)?, failure: ((String) -> Void)?)
    func buyBenefits(id: Int, success:((BenefitsResponseEntity) -> Void)?, failure: ((String) -> Void)?)
}

final class BenefitsInteractor {

    private let networkProvider = MainNetworkProvider<BenefitsService>()

}

// MARK: - IChangePasswordInteractor implementation

extension BenefitsInteractor: IBenefitsInteractor {

    func getBenefits(success: ((BenefitsResponseEntity) -> Void)?, failure: ((String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.request(
            .myCoupons(token),
            type: BenefitsResponseEntity.self,
            completion: { result in
                if result.isSuccess {
                    success?(result)
                } else {
                    failure?(result.message)
                }
            },
            failure: { err in
                failure?(err?.localizedDescription ?? "")
            }
        )
    }

    func buyBenefits(id: Int, success: ((BenefitsResponseEntity) -> Void)?, failure: ((String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.request(
            .buyCoupon(id, token),
            type: BenefitsResponseEntity.self,
            completion: { result in
                if result.isSuccess {
                    success?(result)
                } else {
                    failure?(result.message)
                }
            },
            failure: { err in
                failure?(err?.localizedDescription ?? "")
            }
        )
    }

}
