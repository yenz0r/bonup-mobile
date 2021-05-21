//
//  TaskDescriptionBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 06.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITaskDescriptionBuilder {
    func build(_ dependency: TaskDescriptionDependency) -> ITaskDescriptionRouter
}

final class TaskDescriptionBuilder: ITaskDescriptionBuilder {
    func build(_ dependency: TaskDescriptionDependency) -> ITaskDescriptionRouter {
        let view = TaskDescriptionView()
        let router = TaskDescriptionRouter(view: view, parentController: dependency.parentController)
        let interactor = TaskDescriptionInteractor()
        let presenter =  TaskDescriptionPresenter(view: view, interactor: interactor, router: router, currentTask: dependency.currentTask)
        view.presenter = presenter

        return router
    }
}
