//
//  TaskSelectionInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITaskSelectionInteractor: AnyObject {

}

final class TaskSelectionInteractor {

    private let networkProvider = MainNetworkProvider<ResetPasswordService>()

}

// MARK: - ITaskSelectionInteractor implementation

extension TaskSelectionInteractor: ITaskSelectionInteractor {

}
