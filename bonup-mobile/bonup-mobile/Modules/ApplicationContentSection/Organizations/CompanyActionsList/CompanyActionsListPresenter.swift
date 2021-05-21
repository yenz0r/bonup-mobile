//
//  CompanyActionsListPesenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyActionsListPesenter: AnyObject {
    
    var numberOfActions: Int { get }
    
    var controllerTitle: String { get }
    var emtpyDataSetTitle: String { get }

    func actionTitle(at index: Int) -> String
    func actionDescription(at index: Int) -> String
    func actionDateInfo(at index: Int) -> String
    func actionDateInfoColor(at index: Int) -> UIColor
    
    func handleActionSelection(at index: Int)
    func handleViewDidLoad()
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
        
        return self.interactor.actionsList.count
    }
    
    var controllerTitle: String {
        
        switch self.interactor.contentType {
        
        case .coupons:
            return "ui_coupons_title"
            
        case .tasks:
            return "ui_tasks_title"
            
        case .stocks:
            return "ui_stocks_title"
        }
    }
    
    var emtpyDataSetTitle: String {
        
        switch self.interactor.contentType {
        
        case .coupons:
            return "ui_empty_new_benefits_list"
            
        case .tasks:
            return "ui_empty_current_tasks_list"
            
        case .stocks:
            return "ui_empty_current_stocks_list"
        }
    }
    
    func actionTitle(at index: Int) -> String {
        
        return self.interactor.actionsList[index].title
    }
    
    func actionDescription(at index: Int) -> String {
        
        return self.interactor.actionsList[index].descriptionText
    }
    
    func actionDateInfoColor(at index: Int) -> UIColor {
        
        let action = self.interactor.actionsList[index]
        
        let endDate = Date.dateFromTimestamp(action.endDateTimestamp)
        
        return endDate.compare(Date()) == .orderedAscending ? .systemRed : .systemGreen
    }
    
    func actionDateInfo(at index: Int) -> String {
       
        let action = self.interactor.actionsList[index]
        
        let startDate = Date.dateFromTimestamp(action.startDateTimestamp)
        let endDate = Date.dateFromTimestamp(action.endDateTimestamp)
        
        return "\(self.dateFormatter.string(from: startDate)) / \(self.dateFormatter.string(from: endDate))"
    }
    
    func handleActionSelection(at index: Int) {
        
        let action = self.interactor.actionsList[index] 
        
        self.router.show(.showActionDetails(mode: self.interactor.contentType,
                                            action: action))
    }
    
    func handleViewDidLoad() {
        
        switch self.interactor.contentMode {
        
        case .show:
            self.view?.reloadData()
            
        case .load(let name):
            self.interactor.loadActions(companyName: name) { isSuccess in
                
                if isSuccess {
                    
                    DispatchQueue.main.async {
                        
                        self.view?.reloadData()
                    }
                }
            }
        }
    }
}
