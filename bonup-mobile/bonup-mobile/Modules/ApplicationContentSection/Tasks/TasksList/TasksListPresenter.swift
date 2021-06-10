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

    var pages: [String] { get }

    func handleShowDetailsTap(with index: Int)
    func handleShowHelp()
    
    func viewWillAppear()
}

final class TasksListPresenter {
    
    // MARK: - Private variables
    
    private weak var view: ITasksListView?
    private let interactor: ITasksListInteractor
    private let router: ITasksListRouter

    // MARK: - Data variables
    
    private var currentListResponse: TaskListResponseEntity?

    // MARK: - State variables
    
    private var isFirstRefresh = true
    
    // MARK: - Init
    
    init(view: ITasksListView?,
         interactor: ITasksListInteractor,
         router: ITasksListRouter) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskSelectionPresenter implementation

extension TasksListPresenter: ITasksListPresenter {

    var pages: [String] {

        return [
            "current_tasks_title",
            "finished_tasks_title"
        ]
    }

    var currentTasksList: [CurrentTasksListPresentationModel] {

        guard let currentResponse = self.currentListResponse else { return [] }

        var result = [CurrentTasksListPresentationModel]()

        for current in currentResponse.saved {

            let model = CurrentTasksListPresentationModel(
                title: current.name,
                description: current.description,
                imageLink: PhotosService.photoPath(for: current.photoId),
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
                benefit: "\(finished.bonusesCount)"
            )

            result.append(model)
        }

        return result
    }


    func viewWillAppear() {
        
        self.interactor.getTasks(
            withLoader: true,
            success: { [weak self] result in

                self?.currentListResponse = result
                
                DispatchQueue.main.async {
                 
                    self?.view?.reloadData()
                }
            },
            failure: { status, message in }
        )
        
        if self.isFirstRefresh {
            
            self.isFirstRefresh.toggle()
        }
    }

    func handleShowDetailsTap(with index: Int) {

        guard let currents = self.currentListResponse?.saved else { return }

        self.router.show(.showTaskDescription(currents[index], { [weak self] in
            
            self?.isFirstRefresh = true
            self?.viewWillAppear()
        }))
    }
    
    func handleShowHelp() {
        
        self.router.show(.showHelpMessage)
    }
}
