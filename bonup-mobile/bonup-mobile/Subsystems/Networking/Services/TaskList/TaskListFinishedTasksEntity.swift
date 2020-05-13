//
//  TaskFinishedTasks.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct TaskListFinishedTasksEntity: Codable {
    let isDied: Bool
    let isResolved: Bool
    
    let id: Int

    let name: String
    let dateFrom: String
    let dateTo: String
    let description: String
    let count: Int

    let organizationName: String
    let x: Float
    let y: Float
    let contactNumber: String
    let organizationDescription: String

    let subcategoryId: Int
    let subcategory: String
    let categoryId: Int
    let category: String

    let typeId: Int
    let type: String
    let ballCount: Int

    let photos: [String]
}
