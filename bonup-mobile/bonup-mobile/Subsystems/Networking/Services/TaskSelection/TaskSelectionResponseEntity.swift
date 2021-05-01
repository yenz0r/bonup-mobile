//
//  TaskSelectionResponseEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct TaskSelectionResponseEntity: Codable {
    let id: Int
    let name: String
    let dateFrom: String
    let dateTo: String
    let description: String
    let count: Int
    let organizationName: String
    let subcategoryId: Int
    let subcategory: String
    let categoryId: Int
    let category: String
    let typeId: Int
    let type: String
    let pointsCount: Int
    let photos: [Int]
    let activity: Bool
    let accepted: Bool
    let rejected: Bool
    let done: Bool
}
