//
//  TasksListPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import UIKit

protocol ITasksListPresenter: AnyObject {
    var currentTasksList: [String] { get }
    var finishedTasksList: [String] { get }

    func handleShowDetailsTap(with index: Int)
}

final class TasksListPresenter {
    private weak var view: ITasksListView?
    private let interactor: ITasksListInteractor
    private let router: ITasksListRouter

    init(view: ITasksListView?, interactor: ITasksListInteractor, router: ITasksListRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskSelectionPresenter implementation

extension TasksListPresenter: ITasksListPresenter {
    var currentTasksList: [String] {
        return []
    }

    var finishedTasksList: [String] {
        return []
    }

    func handleShowDetailsTap(with index: Int) {
        self.router.show(.showTaskDescription)
    }
}
