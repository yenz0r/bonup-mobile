//
//  AddCompanyDependency.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

struct AddCompanyDependency {
    
    enum Mode {
        
        case create, modify, read
    }
    
    let parentNavigationController: UINavigationController
    let initCompany: CompanyEntity?
    let mode: Mode
    
    let companyPacket: CompanyPacketType?
}
