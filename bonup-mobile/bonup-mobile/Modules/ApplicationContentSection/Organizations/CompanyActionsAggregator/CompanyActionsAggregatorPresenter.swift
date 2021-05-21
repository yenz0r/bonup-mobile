//
//  CompanyActionsAggregatorPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyActionsAggregatorPresenter: AnyObject {

    var sections: [String] { get }
    
    var companyName: String { get }

    func handleHelp(forSection index: Int)
}

final class CompanyActionsAggregatorPresenter {

    // MARK: - Private variables

    private weak var view: ICompanyActionsAggregatorView?
    private let interactor: ICompanyActionsAggregatorInteractor
    private let router: ICompanyActionsAggregatorRouter

    // MARK: - Init

    init(view: ICompanyActionsAggregatorView?, interactor: ICompanyActionsAggregatorInteractor, router: ICompanyActionsAggregatorRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICompanySearchPresenter

extension CompanyActionsAggregatorPresenter: ICompanyActionsAggregatorPresenter {

    var sections: [String] {
        return ["ui_tasks_title".localized,
                "ui_coupons_title".localized,
                "ui_stocks_title".localized]
    }
    
    var companyName: String {
        
        return self.interactor.companyName
    }

    func handleHelp(forSection index: Int) {

        if index == 0 {
            
            self.router.show(.infoAlert("ui_company_tasks_help_message".localized))
        }
        else if index == 1 {
            
            self.router.show(.infoAlert("ui_company_coupons_help_message".localized))
        }
        else {
            
            self.router.show(.infoAlert("ui_company_stocks_help_message".localized))
        }
    }
}
