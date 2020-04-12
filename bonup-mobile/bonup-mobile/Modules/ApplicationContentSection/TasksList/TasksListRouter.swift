//
//  TasksListRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ITasksListRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: TasksListRouter.TasksListRouterScenario)
}

final class TasksListRouter {
    enum TasksListRouterScenario {
        case showTasksList
    }

    private var view: TasksListView?
    private var parentController: UIViewController

    init(view: TasksListView?, parentController: UIViewController) {
        self.view = view
        self.parentController = parentController
    }
}

// MARK: - ICategoriesRouter implementation

extension TasksListRouter: ITasksListRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentController.navigationController?.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentController.navigationController?.popToRootViewController(animated: true)
        completion?()
        self.view = nil
    }

    func show(_ scenario: TasksListRouterScenario) {

        switch scenario {
        case .showTasksList:
            print("tasks list")
        }

    }

}
