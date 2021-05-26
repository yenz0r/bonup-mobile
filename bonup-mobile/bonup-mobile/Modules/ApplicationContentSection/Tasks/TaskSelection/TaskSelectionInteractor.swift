//
//  TaskSelectionInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITaskSelectionInteractor: AnyObject {

    func getTasks(withLoader: Bool,
                  completion: (([TaskSelectionResponseEntity], Bool) -> Void)?)
    
    func saveTasks(ids: [Int], withLoader: Bool, completion: ((Bool) -> Void)?)
}

final class TaskSelectionInteractor {

    private lazy var networkProvider = MainNetworkProvider<TaskSelectionService>()
}

// MARK: - ITaskSelectionInteractor implementation

extension TaskSelectionInteractor: ITaskSelectionInteractor {
    
    func getTasks(withLoader: Bool,
                  completion: (([TaskSelectionResponseEntity], Bool) -> Void)?) {
        
        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.request(
            .getTasks(token),
            type: [TaskSelectionResponseEntity].self,
            withLoader: withLoader,
            completion: { result  in

                completion?(result, true)
            },
            failure: { _ in

                completion?([], false)
            }
        )
    }

    func saveTasks(ids: [Int], withLoader: Bool, completion: ((Bool) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.request(
            .saveTasks(token, ids),
            type: DefaultResponseEntity.self,
            withLoader: withLoader,
            completion: { result in
                
                completion?(result.isSuccess)
            },
            failure: { err in
                
                completion?(false)
            })
    }
}
