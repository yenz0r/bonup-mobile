//
//  TaskSelectionBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITaskSelectionBuilder {
    func build(_ dependency: TaskSelectionDependency) -> ITaskSelectionRouter
}

final class TaskSelectionBuilder: ITaskSelectionBuilder {
    func build(_ dependency: TaskSelectionDependency) -> ITaskSelectionRouter {
        let view = TaskSelectionView()
        let router = TaskSelectionRouter(view: view, parentNavigationController: dependency.parentNavigationController)
        let interactor = TaskSelectionInteractor()
        let presenter =  TaskSelectionPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
