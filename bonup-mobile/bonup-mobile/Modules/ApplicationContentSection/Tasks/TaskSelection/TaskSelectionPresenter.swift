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
    
    // MARK: - Private variables
    
    private weak var view: ITaskSelectionView?
    private let interactor: ITaskSelectionInteractor
    private let router: ITaskSelectionRouter

    // MARK: - Data variables
    
    private var selectedCards = [TaskCardEntity]()
    private var taskCardEntities = [TaskCardEntity]()

    // MARK: - State variables
    
    private var isFirstRefresh = true
    private var willShowLists = false
    
    // MARK: - Init
    
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
        
        self.interactor.getTasks(withLoader: self.isFirstRefresh) { [weak self] (responseEntities, isSuccess) in

            self?.taskCardEntities = responseEntities.map { entity in
                return TaskCardEntity(
                    id: entity.id,
                    title: entity.name,
                    description: entity.description,
                    imageLink: PhotosService.photoPath(for: entity.photoId),
                    categoryLocTitle: InterestCategories.category(id: entity.categoryId).title
                )
            }
            
            DispatchQueue.main.async {
             
                self?.view?.reloadData()
            }
        }
        
        if self.isFirstRefresh {
            
            self.isFirstRefresh.toggle()
        }
    }

    func viewWillDisappear() {

        let selectedIds = self.selectedCards.map { $0.id }
        
        if self.willShowLists, selectedIds.count == 0 { return }

        self.interactor.saveTasks(ids: selectedIds, withLoader: false) { isSuccess in
            
            if isSuccess {
                    
                self.selectedCards = []
            }
        }
    }

    func handleInfoButtonTap() {

        self.router.show(.showInfoAlert)
    }

    func handleShowTasksListButtonTap() {
        
        let selectedIds = self.selectedCards.map { $0.id }
        
        if selectedIds.count == 0 { self.router.show(.showTasksList); return }

        self.interactor.saveTasks(ids: selectedIds, withLoader: true) { isSuccess in
            
            DispatchQueue.main.async {
             
                if isSuccess {
         
                    self.willShowLists = true
                    self.selectedCards = []
                    self.router.show(.showTasksList)
                }
                else {
                 
                    self.router.show(.showErrorAlert("ui_error_title".localized))
                }
            }
        }
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
