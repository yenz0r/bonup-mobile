//
//  OrganizationControlInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IOrganizationControlInteractor: AnyObject {

    func resolveTask(qrCode: String, block: ((Bool, String) -> Void)?)
    func activateCoupon(qrCode: String, block: ((Bool, String) -> Void)?)
    func addTask(name: String, descriptionText: String, count: Int, type: Int, success:((String) -> Void)?, failure:((String) -> Void)?)
    func addBenefit(name: String, descriptionText: String, count: Int, type: Int, success:((String) -> Void)?, failure:((String) -> Void)?)
}

final class OrganizationControlInteractor {

    private let networkProvider = MainNetworkProvider<OrganizationControlService>()

    private let organizationName: String

    init(organizationName: String) {
        self.organizationName = organizationName
    }

}

// MARK: - IChangePasswordInteractor implementation

extension OrganizationControlInteractor: IOrganizationControlInteractor {

    func addTask(name: String, descriptionText: String, count: Int, type: Int, success:((String) -> Void)?, failure:((String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.request(
            .putTask(name, descriptionText, count, type, token, organizationName),
            type: OrganizationAppendResponseEntity.self,
            completion: { result in
                if result.isSuccess {
                    success?(result.message)
                } else {
                    failure?(result.message)
                }
            },
            failure: { err in
                failure?(err?.localizedDescription ?? "")
            }
        )
    }

    func addBenefit(name: String, descriptionText: String, count: Int, type: Int, success:((String) -> Void)?, failure:((String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.request(
            .putCoupon(name, descriptionText, count, type, token, organizationName),
            type: OrganizationAppendResponseEntity.self,
            completion: { result in
                if result.isSuccess {
                    success?(result.message)
                } else {
                    failure?(result.message)
                }
            },
            failure: { err in
                failure?(err?.localizedDescription ?? "")
            }
        )
    }

    func resolveTask(qrCode: String, block: ((Bool, String) -> Void)?) {

        guard let orgToken = AccountManager.shared.currentToken else { return }

        let componets = qrCode.components(separatedBy: "-")

        guard let id = Int(componets[0]) else { return }

        _ = self.networkProvider.request(
            .resolveTask(id, componets[1], orgToken),
            type: OrganizationControlResponseEntity.self,
            completion: { result in

                block?(result.isSuccess, result.message)
            },
            failure: { err in

                block?(false, err?.localizedDescription ?? "")
            }
        )
    }

    func activateCoupon(qrCode: String, block: ((Bool, String) -> Void)?) {

        guard let orgToken = AccountManager.shared.currentToken else { return }

        let componets = qrCode.components(separatedBy: "-")

        guard let id = Int(componets[0]) else { return }

        _ = self.networkProvider.request(
            .activateCoupon(id, componets[1], orgToken),
            type: OrganizationControlResponseEntity.self,
            completion: { result in

                block?(result.isSuccess, result.message)
            },
            failure: { err in

                block?(false, err?.localizedDescription ?? "")
            }
        )
    }
}
