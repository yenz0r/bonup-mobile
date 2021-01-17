//
//  CompanySearchPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompaniesSearchPresenter: AnyObject {
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

}
