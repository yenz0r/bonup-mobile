//
//  CategoriesPresenter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ICategoriesPresenter {

}

final class CategoriesPresenter {
    private weak var view: ICategoriesView?
    private let interactor: ICategoriesInteractor
    private let router: ICategoriesRouter

    init(view: ICategoriesView?, interactor: ICategoriesInteractor, router: ICategoriesRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICategoriesPresenter implementation

extension CategoriesPresenter: ICategoriesPresenter {
    
}
