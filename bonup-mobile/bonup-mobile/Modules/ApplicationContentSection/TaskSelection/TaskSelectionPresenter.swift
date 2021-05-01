//
//  TaskSelectionPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ITaskSelectionPresenter: AnyObject {
    func handleTaskSelection(at index: Int, isLike: Bool)
    func handleReturnButtonTap()
    func handleInfoButtonTap()
    func handleShowTasksListButtonTap()
    func cardForIndex(_ index: Int) -> TaskCardEntity
    func numberOfCards() -> Int
    func viewWillAppear()
    func viewWillDisappear()
}

final class TaskSelectionPresenter {
    private weak var view: ITaskSelectionView?
    private let interactor: ITaskSelectionInteractor
    private let router: ITaskSelectionRouter

    private var selectedCards = [TaskCardEntity]()
    private var taskCardEntities = [TaskCardEntity]()

    init(view: ITaskSelectionView?, interactor: ITaskSelectionInteractor, router: ITaskSelectionRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskSelectionPresenter implementation

extension TaskSelectionPresenter: ITaskSelectionPresenter {
    func cardForIndex(_ index: Int) -> TaskCardEntity {

        return self.taskCardEntities[index]
    }

    func numberOfCards() -> Int {

        return self.taskCardEntities.count
    }

    func viewWillAppear() {

        self.interactor.getTasks { [weak self] (responseEntities, isSuccess) in

            self?.taskCardEntities = responseEntities.map { entity in
                return TaskCardEntity(
                    id: entity.id,
                    title: entity.name,
                    description: entity.description,
                    imageLink: String(entity.photos.first ?? 0)
                )
            }
            self?.view?.reloadData()
        }
    }

    func viewWillDisappear() {

        let selectedIds = self.selectedCards.map { $0.id }

        self.interactor.saveTasks(ids: selectedIds, completion: nil)

        self.selectedCards = []
    }

    func handleInfoButtonTap() {

        self.router.show(.showInfoAlert)
    }

    func handleShowTasksListButtonTap() {
        
        self.router.show(.showTasksList)
    }

    func handleTaskSelection(at index: Int, isLike: Bool) {

        let card = self.taskCardEntities[index]

        if isLike {

            var isContains = false

            for localCard in selectedCards {
                if localCard.id == card.id {
                    isContains = true
                    break
                }
            }

            if !isContains {
                self.selectedCards.append(card)
            }
        } else {

            self.selectedCards.removeAll { $0.id == card.id }
        }
    }

    func handleReturnButtonTap() {
        
        self.view?.returnPrevCard()
    }
}
