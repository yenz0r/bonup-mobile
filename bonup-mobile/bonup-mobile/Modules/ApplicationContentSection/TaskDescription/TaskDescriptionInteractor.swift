//
//  TaskDescriptionInreractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 06.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITaskDescriptionInteractor: AnyObject {
}

final class TaskDescriptionInteractor {

    // MARK: - Private variables

    private let networkProvider = MainNetworkProvider<NewPasswordService>()
    private let taskId: Int

    // MARK: - Initialization

    init(taskId: Int) {
        self.taskId = taskId
    }
}

// MARK: - ITaskDescriptionInteractor implementation

extension TaskDescriptionInteractor: ITaskDescriptionInteractor {
}
