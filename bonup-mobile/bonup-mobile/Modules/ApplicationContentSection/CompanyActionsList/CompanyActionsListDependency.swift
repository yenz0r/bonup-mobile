//
//  CompanyActionsListDependency.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

struct CompanyActionsListDependency {
    
    enum ContentType: Int {
        
        case coupons = 0, tasks, stocks
    }
    
    enum ContentMode {
        
        case show, load(organizationName: String)
    }
    
    var parentNavigationController: UINavigationController
    var contentType: ContentType
    var contentMode: ContentMode
    var actions: [OrganizationActionEntity]?
}
