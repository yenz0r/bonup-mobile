//
//  CompanyActionsListPesenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyActionsListPesenter: AnyObject {
    
    var numberOfActions: Int { get }
    
    var controllerTitle: String { get }
    var emtpyDataSetTitle: String { get }

    func actionTitle(at index: Int) -> String
    func actionDescription(at index: Int) -> String
    func actionDateInfo(at index: Int) -> String
    
    func handleActionSelection(at index: Int)
}

final class CompanyActionsListPresenter {

    // MARK: - Private variables

    private weak var view: ICompanyActionsListView?
    private let interactor: ICompanyActionsListInteractor
    private let router: ICompanyActionsListRouter
    
    // MARK: - Services
    
    private lazy var dateFormatter = Date.dateFormatter

    // MARK: - Init

    init(view: ICompanyActionsListView?,
         interactor: ICompanyActionsListInteractor,
         router: ICompanyActionsListRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICompanyCustomPacketPresenter

extension CompanyActionsListPresenter: ICompanyActionsListPesenter {
    
    var numberOfActions: Int {
        
        return self.interactor.actionsList?.count ?? 0
    }
    
    var controllerTitle: String {
        
        switch self.interactor.currentMode {
        
        case .coupons:
            return "ui_coupons_title"
            
        case .tasks:
            return "ui_tasks_title"
        }
    }
    
    var emtpyDataSetTitle: String {
        
        switch self.interactor.currentMode {
        
        case .coupons:
            return "ui_empty_new_benefits_list"
            
        case .tasks:
            return "ui_empty_current_tasks_list"
        }
    }
    
    func actionTitle(at index: Int) -> String {
        
        return self.interactor.actionsList?[index].title ?? ""
    }
    
    func actionDescription(at index: Int) -> String {
        
        return self.interactor.actionsList?[index].descriptionText ?? ""
    }
    
    func actionDateInfo(at index: Int) -> String {
       
        guard let action = self.interactor.actionsList?[index] else { return "-" }
        
        let startDate = Date.dateFromTimestamp(action.startDateTimestamp)
        let endDate = Date.dateFromTimestamp(action.endDateTimestamp)
        
        return "\(self.dateFormatter.string(from: startDate)) / (\(self.dateFormatter.string(from: endDate))"
    }
    
    func handleActionSelection(at index: Int) {
        
        guard let action = self.interactor.actionsList?[index] else { return }
        
        self.router.show(.showActionDetails(mode: self.interactor.currentMode,
                                            action: action))
    }
}
