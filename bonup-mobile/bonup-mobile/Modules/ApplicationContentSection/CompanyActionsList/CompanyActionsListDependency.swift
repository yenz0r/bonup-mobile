//
//  CompanyActionsListDependency.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

struct CompanyActionsListDependency {
    
    enum Mode {
        
        case coupons, tasks
    }
    
    var parentNavigationController: UINavigationController
    var mode: Mode
    var actions: [OrganizationControlAppendRequestEntity]
}
