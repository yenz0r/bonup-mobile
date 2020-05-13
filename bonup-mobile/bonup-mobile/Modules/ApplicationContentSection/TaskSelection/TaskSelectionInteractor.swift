//
//  TaskSelectionInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITaskSelectionInteractor: AnyObject {

    func getTasks(completion: (([TaskSelectionResponseEntity], Bool) -> Void)?)
    func saveTasks(ids: [Int], completion: ((Bool) -> Void)?)
}

final class TaskSelectionInteractor {

    private let networkProvider = MainNetworkProvider<TaskSelectionService>()

}

// MARK: - ITaskSelectionInteractor implementation

extension TaskSelectionInteractor: ITaskSelectionInteractor {
    func getTasks(completion: (([TaskSelectionResponseEntity], Bool) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.request(
            .getTasks(token),
            type: [TaskSelectionResponseEntity].self,
            completion: { result  in

                completion?(result, true)
            },
            failure: { _ in

                completion?([], false)
            }
        )
    }

    func saveTasks(ids: [Int], completion: ((Bool) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.requestSignal(.saveTasks(token, ids))
    }
}
