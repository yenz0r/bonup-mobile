//
//  TasksListBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITasksListBuilder {
    func build(_ dependency: TasksListDependency) -> ITasksListRouter
}

final class TasksListBuilder: ITasksListBuilder {
    func build(_ dependency: TasksListDependency) -> ITasksListRouter {
        let view = TasksListView()
        let router = TasksListRouter(view: view, parentController: dependency.parentController)
        let interactor = TasksListInteractor()
        let presenter =  TasksListPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
