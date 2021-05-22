//
//  TaskFinishedTasks.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct TaskListFinishedTasksEntity: Decodable {
    
    let isDied: Bool
    let isResolved: Bool
    
    let id: Int

    let name: String
    let dateFrom: String
    let dateTo: String
    let description: String

    let organization: CompanyEntity

    let categoryId: Int
    let bonusesCount: Int
    let photoId: Int
}
