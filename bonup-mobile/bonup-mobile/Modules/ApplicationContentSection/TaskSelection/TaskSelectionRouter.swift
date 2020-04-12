//
//  TaskSelectionRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ITaskSelectionRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: TaskSelectionRouter.TaskSelectionRouterScenario)
}

final class TaskSelectionRouter {
    enum TaskSelectionRouterScenario {
        case showTasksList
    }

    private var view: TaskSelectionView?
    private var parentNavigationController: UINavigationController

    init(view: TaskSelectionView?, parentNavigationController: UINavigationController) {
        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICategoriesRouter implementation

extension TaskSelectionRouter: ITaskSelectionRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentNavigationController.pushViewController(view, animated: false)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentNavigationController.popToRootViewController(animated: true)
        completion?()
        self.view = nil
    }

    func show(_ scenario: TaskSelectionRouterScenario) {

        switch scenario {
        case .showTasksList:
            print("tasks list")
        }

    }

}
