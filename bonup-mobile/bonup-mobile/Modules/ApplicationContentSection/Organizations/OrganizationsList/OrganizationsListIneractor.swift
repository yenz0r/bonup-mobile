//
//  OrganizationsListIneractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IOrganizationsListInteractor: AnyObject {

    func getOrganizationsList(withLoader: Bool,
                              success:(() -> Void)?,
                              failure:((Bool, String) -> Void)?)
    
    var companies: [CompanyEntity]? { get }
}

final class OrganizationsListInteractor {

    // MARK: - Private variables
    
    private lazy var networkProvider = MainNetworkProvider<OrganizationsListService>()
    
    // MARK: - Public variables
    
    var companies: [CompanyEntity]?
}

// MARK: - IChangePasswordInteractor implementation

extension OrganizationsListInteractor: IOrganizationsListInteractor {

    func getOrganizationsList(withLoader: Bool,
                              success: (() -> Void)?,
                              failure: ((Bool, String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = self.networkProvider.request(
            .getOrganizations(token),
            type: [CompanyEntity].self,
            withLoader: withLoader,
            completion: { [weak self] result in

                self?.companies = result
                
                success?()
            },
            failure: { err in
                
                failure?(false, err?.localizedDescription ?? "")
            }
        )
    }
}
