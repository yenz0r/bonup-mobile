//
//  TaskSelectionPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import UIKit

protocol ITaskSelectionPresenter: AnyObject {
    func handleTaskSelection(at index: Int, isLike: Bool)
    func handleReturnButtonTap()
}

final class TaskSelectionPresenter {
    private weak var view: ITaskSelectionView?
    private let interactor: ITaskSelectionInteractor
    private let router: ITaskSelectionRouter

    init(view: ITaskSelectionView?, interactor: ITaskSelectionInteractor, router: ITaskSelectionRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskSelectionPresenter implementation

extension TaskSelectionPresenter: ITaskSelectionPresenter {
    func handleTaskSelection(at index: Int, isLike: Bool) {
        print(index, isLike)
    }

    func handleReturnButtonTap() {
        self.view?.returnPrevCard()
    }
}
