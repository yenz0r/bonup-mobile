//
//  CompanySearchPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompaniesSearchPresenter: AnyObject {

    var categories: [CompaniesSearchCategoryModel] { get }
}

final class CompaniesSearchPresenter {

    // MARK: - Private variables

    private weak var view: ICompaniesSearchView?
    private let interactor: ICompaniesSearchInteractor
    private let router: ICompaniesSearchRouter

    // MARK: - Init

    init(view: ICompaniesSearchView?, interactor: ICompaniesSearchInteractor, router: ICompaniesSearchRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICompanySearchPresenter

extension CompaniesSearchPresenter: ICompaniesSearchPresenter {
    
    var categories: [CompaniesSearchCategoryModel] {

        return [
            CompaniesSearchCategoryModel(title: "123", isActive: true),
            CompaniesSearchCategoryModel(title: "12313213", isActive: false),
            CompaniesSearchCategoryModel(title: "123", isActive: false),
            CompaniesSearchCategoryModel(title: "12313213", isActive: true),
            CompaniesSearchCategoryModel(title: "123", isActive: false),
            CompaniesSearchCategoryModel(title: "12313213", isActive: true),
            CompaniesSearchCategoryModel(title: "123", isActive: false),
            CompaniesSearchCategoryModel(title: "12313213", isActive: false)
        ]
    }

    
}
