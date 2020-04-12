//
//  TasksListInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITasksListInteractor: AnyObject {

}

final class TasksListInteractor {

    private let networkProvider = MainNetworkProvider<ResetPasswordService>()

}

// MARK: - ITaskSelectionInteractor implementation

extension TasksListInteractor: ITasksListInteractor {



}
