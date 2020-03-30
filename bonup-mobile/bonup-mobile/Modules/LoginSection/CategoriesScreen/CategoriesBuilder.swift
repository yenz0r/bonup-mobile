//
//  CategoriesBuilder.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ICategoriesBuilder {
    func build(_ dependency: CategoriesDependency) -> ICategoriesRouter
}

final class CategoriesBuilder: ICategoriesBuilder {
    func build(_ dependency: CategoriesDependency) -> ICategoriesRouter {
        let view = CategoriesView()
        let router = CategoriesRouter(view: view, parentController: dependency.parentViewController)
        let interactor = CategoriesInteractor()
        let presenter =  CategoriesPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
