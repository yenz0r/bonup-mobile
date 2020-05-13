//
//  TaskListResponseEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct TaskListResponseEntity: Codable {
    
    let message: String
    let isSuccess: Bool
    let saved: [TaskListCurrentTasksEntity]
    let finished: [TaskListFinishedTasksEntity]
}
