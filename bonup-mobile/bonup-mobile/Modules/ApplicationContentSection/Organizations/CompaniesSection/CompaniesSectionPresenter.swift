//
//  CompaniesSectionPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompaniesSectionPresenter: AnyObject {

    var sections: [String] { get }

    func handleHelp(forSection index: Int)
}

final class CompaniesSectionPresenter {

    // MARK: - Private variables

    private weak var view: ICompaniesSectionView?
    private let interactor: ICompaniesSectionInteractor
    private let router: ICompaniesSectionRouter

    // MARK: - Init

    init(view: ICompaniesSectionView?, interactor: ICompaniesSectionInteractor, router: ICompaniesSectionRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICompanySearchPresenter

extension CompaniesSectionPresenter: ICompaniesSectionPresenter {

    var sections: [String] {
        return ["ui_all",
                "ui_my"]
    }

    func handleHelp(forSection index: Int) {

        self.router.show(.infoAlert(index == 0 ? "ui_all_companies_help_message".localized : "ui_my_companies_help_message".localized))
    }
}
