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
    
    var currentCompany: CompanyEntity { get }
}

final class OrganizationControlInteractor {

    // MARK: - Private properties
    
    private let networkProvider = MainNetworkProvider<OrganizationControlService>()
    
    // MARK: - Public properties
    
    var currentCompany: CompanyEntity

    // MARK: - Init
    
    init(currentCompany: CompanyEntity) {
        
        self.currentCompany = currentCompany
    }
}

// MARK: - IChangePasswordInteractor implementation

extension OrganizationControlInteractor: IOrganizationControlInteractor {

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
