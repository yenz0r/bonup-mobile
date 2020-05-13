//
//  OrganizationsListIneractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IOrganizationsListInteractor: AnyObject {

    func getOrganizationsList(success:((OrganizationsListResponseEntity) -> Void)?, failure:((Bool, String) -> Void)?)
}

final class OrganizationsListInteractor {

    private let networkProvider = MainNetworkProvider<OrganizationsListService>()

}

// MARK: - IChangePasswordInteractor implementation

extension OrganizationsListInteractor: IOrganizationsListInteractor {

    func getOrganizationsList(success: ((OrganizationsListResponseEntity) -> Void)?,
                              failure: ((Bool, String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = self.networkProvider.request(
            .getOrganizations(token),
            type: OrganizationsListResponseEntity.self,
            completion: { result in

                success?(result)
            },
            failure: { err in
                failure?(false, err?.localizedDescription ?? "")
            }
        )
    }
}
