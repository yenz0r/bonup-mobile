//
//  OrganizationAppendRequestEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 1.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

struct OrganizationControlAppendRequestEntity {
    
    var title: String = ""
    var descriptionText: String = ""
    var categoriesIds: [Int] = []
    var token: String = ""
    var bonusesCount: Int = 0
    var organizationId: String = ""
    var startDateTimestamp: Double = 0
    var endDateTimestamp: Double = 0
}
