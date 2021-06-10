//
//  CompanyActionsStatisticsEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 10.06.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

struct CompanyActionsStatisticsEntity: Decodable {

    let actions: [OrganizationActionEntity]
    let count: Int
}
