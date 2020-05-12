//
//  OrganizationsListIneractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IOrganizationsListInteractor: AnyObject {
}

final class OrganizationsListInteractor {

    private let networkProvider = MainNetworkProvider<NewPasswordService>()

}

// MARK: - IChangePasswordInteractor implementation

extension OrganizationsListInteractor: IOrganizationsListInteractor {
}
