//
//  CompanyStatisticsEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

struct CompanyStatisticsEntity: Decodable {
    
    let tasks: [OrganizationActionEntity]
    let coupons: [OrganizationActionEntity]
}
