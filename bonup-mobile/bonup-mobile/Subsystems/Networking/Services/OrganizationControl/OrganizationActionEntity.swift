//
//  OrganizationAppendRequestEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 1.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

struct OrganizationActionEntity: Decodable {
    
    var title: String = ""
    var descriptionText: String = ""
    var categoryId: Int = 0
    var bonusesCount: Int = 0
    var organizationName: String = ""
    var startDateTimestamp: Double = 0
    var endDateTimestamp: Double = 0
    var allowedCount: Int = 0
    var photoId: Int = 0
}
