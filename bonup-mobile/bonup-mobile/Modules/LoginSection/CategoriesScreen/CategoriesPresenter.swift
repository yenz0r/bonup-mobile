//
//  CategoriesPresenter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ICategoriesPresenter {
    var categories: [CategoriesPresentationModel] { get }

    func handleViewDidLoad()
    func handleViewDidDisappear()

    func handleSkipButtonTap()
    func handleCardSwipe(at index: Int, isLike: Bool)
}

final class CategoriesPresenter {
    private weak var view: ICategoriesView?
    private let interactor: ICategoriesInteractor
    private let router: ICategoriesRouter

    private var responseCategories = [CategoryInfo]()
    private var selectedIds = [Int]()

    init(view: ICategoriesView?, interactor: ICategoriesInteractor, router: ICategoriesRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICategoriesPresenter implementation

extension CategoriesPresenter: ICategoriesPresenter {

    var categories: [CategoriesPresentationModel] {
        var resultCategories = [CategoriesPresentationModel]()
        for info in self.responseCategories {
            resultCategories.append(
                CategoriesPresentationModel(
                    title: info.name,
                    description: info.description
                )
            )
        }
        return resultCategories
    }

    func handleViewDidLoad() {
        self.interactor.categotiesListRequest(
            success: { categoryInfo in
                DispatchQueue.main.async {
                    self.responseCategories = categoryInfo
                    self.view?.relaodData()
                }
            },
            failure: {
                print("fail")
            }
        )
    }

    func handleViewDidDisappear() {
        self.interactor.saveSeletedCategoriesRequest(selectedIds: self.selectedIds)
    }

    func handleSkipButtonTap() {
        self.router.show(.openApplication)
    }

    func handleCardSwipe(at index: Int, isLike: Bool) {
        self.selectedIds.append(self.responseCategories[index].id)

        if index == self.responseCategories.count - 1 {
            self.router.show(.openApplication)
        }
    }
}
