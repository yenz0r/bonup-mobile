//
//  ProfileResponseEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct ProfileResponseDetailsEntity: Decodable {

    let photoId: Int?
    let name: String
    let email: String
    let organizationName: String

    let balls: Int
    let tasksNumber: Int
    let spentBalls: Int

    let finishedTasks: [OrganizationActionEntity]
    let finishedCoupons: [OrganizationActionEntity]

    let goals: [ProfileGoalsResponse]
}
