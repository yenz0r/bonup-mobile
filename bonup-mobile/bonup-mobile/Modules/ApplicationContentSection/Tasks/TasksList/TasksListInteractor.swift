//
//  TasksListInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITasksListInteractor: AnyObject {

    func getTasks(withLoader: Bool,
                  success: ((TaskListResponseEntity) -> Void)?,
                  failure: ((Bool, String) -> Void)?)
}

final class TasksListInteractor {

    private let networkProvider = MainNetworkProvider<TaskListService>()

}

// MARK: - ITaskSelectionInteractor implementation

extension TasksListInteractor: ITasksListInteractor {

    func getTasks(withLoader: Bool,
                  success: ((TaskListResponseEntity) -> Void)?,
                  failure: ((Bool, String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.request(
            .getLists(token),
            type: TaskListResponseEntity.self,
            withLoader: withLoader,
            completion: { result in

                success?(result)
            },
            failure: { err in

                failure?(false, err?.localizedDescription ?? "")
            }
        )

    }
}
