//
//  OrganizationAppendRequestEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 1.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

struct OrganizationControlAppendRequestEntity {
    
    let title: String
    let descriptionText: String
    let categoriesIds: [Int]
    let token: String
    let bonusesCount: Int
}
