//
//  AddCompanyActionDependency.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 25.04.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

struct AddCompanyActionDependency {

    enum Mode {
        
        case create, modify, read
    }
    
    let parentNavigationController: UINavigationController
    let actionType: CompanyActionType
    let organizationId: String?
    let action: OrganizationActionEntity?
    let mode: Mode
}
