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
    var currentTasksList: [CurrentTasksListPresentationModel] { get }
    var finishedTasksList: [FinishedTasksListPresentationModel] { get }

    func handleShowDetailsTap(with index: Int)

    func viewWillAppear()
}

final class TasksListPresenter {
    private weak var view: ITasksListView?
    private let interactor: ITasksListInteractor
    private let router: ITasksListRouter

    private var currentListResponse: TaskListResponseEntity?

    init(view: ITasksListView?, interactor: ITasksListInteractor, router: ITasksListRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskSelectionPresenter implementation

extension TasksListPresenter: ITasksListPresenter {

    var currentTasksList: [CurrentTasksListPresentationModel] {

        guard let currentResponse = self.currentListResponse else { return [] }

        var result = [CurrentTasksListPresentationModel]()

        for current in currentResponse.saved {

            let model = CurrentTasksListPresentationModel(
                title: current.name,
                description: current.description,
                imageLink: current.photos.first ?? "",
                aliveTime: current.dateTo
            )

            result.append(model)
        }

        return result
    }

    var finishedTasksList: [FinishedTasksListPresentationModel] {

        guard let currentResponse = self.currentListResponse else { return [] }

        var result = [FinishedTasksListPresentationModel]()

        for finished in currentResponse.finished {

            let model = FinishedTasksListPresentationModel(
                title: finished.name,
                description: finished.description,
                dateOfEnd: finished.dateTo,
                isDone: finished.isResolved,
                benefit: "\(finished.ballCount)"
            )

            result.append(model)
        }

        return result
    }


    func viewWillAppear() {
        self.interactor.getTasks(
            success: { [weak self] result in

                self?.currentListResponse = result
                self?.view?.reloadData()
            },
            failure: { status, message in
                print("---")
            }
        )
    }

    func handleShowDetailsTap(with index: Int) {

        guard let currents = self.currentListResponse?.saved else { return }

        self.router.show(.showTaskDescription(currents[index]))
    }
}
