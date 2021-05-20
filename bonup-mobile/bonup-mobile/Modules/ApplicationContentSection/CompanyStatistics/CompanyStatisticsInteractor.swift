//
//  CompanyStatisticsInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 2.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyStatisticsInteractor: AnyObject {

    var selectedInfoType: CompanyStatisticsInteractor.InfoType { get set }
    var selectedCategoriesId: [Int] { get set }
    var periodFromDate: Date { get set }
    var periodToDate: Date { get set }
    
    func loadStats(success: (() -> Void)?,
                   failure: ((String) -> Void)?)
    
    var filteredActions: [OrganizationActionEntity] { get }
}

final class CompanyStatisticsInteractor {

    enum InfoType: Int, CaseIterable {
        
        case tasks = 0, coupons
        
        var nonlocalizedTitle: String {
            
            switch self {
            
            case .tasks:
                return "ui_tasks_title"
                
            case .coupons:
                return "ui_coupons_title"
            }
        }
    }
    
    // MARK: - Public variables
    
    var selectedInfoType: CompanyStatisticsInteractor.InfoType = .tasks
    var selectedCategoriesId = [Int]()
    var periodFromDate: Date = Date().withDaysOffset(-7)
    var periodToDate: Date = Date()
    
    // MARK: - Private variables

    private var companyId: String
    private lazy var statsNetworkProvider = MainNetworkProvider<CompanyStatisticsService>()
    private var statsEntity: CompanyStatisticsEntity?
    
    // MARK: - Init
    
    init(companyId: String) {
        
        self.companyId = companyId
        self.loadStats(success: nil, failure: nil)
    }
}

// MARK: - ICompanyStatisticsInteractor implementation

extension CompanyStatisticsInteractor: ICompanyStatisticsInteractor {
 
    func loadStats(success: (() -> Void)?, failure: ((String) -> Void)?) {
        
        guard let token = AccountManager.shared.currentToken else {
            failure?("ui_error_title".localized)
            return
        }
        
        _ = self.statsNetworkProvider.request(
            .getStatistics(token, self.companyId),
            type: CompanyStatisticsEntity.self,
            completion: { [weak self] result in
                
                self?.statsEntity = result
                success?()
            },
            failure: { err in
                
                failure?(err?.localizedDescription ?? "ui_error_title".localized)
            })
    }
    
    var filteredActions: [OrganizationActionEntity] {
        
        guard let stats = self.statsEntity else { return [] }
        
        var actions: [OrganizationActionEntity]
        
        switch self.selectedInfoType {
        case .tasks:
            actions = stats.tasks
            
        case .coupons:
            actions = stats.coupons
        }
        
        return actions
            .filter { self.selectedCategoriesId.contains($0.categoryId) }
            .filter { $0.endDateTimestamp <= self.periodToDate.timestamp }
            .filter { $0.startDateTimestamp >= self.periodFromDate.timestamp }
            .sorted { $0.endDateTimestamp > $1.endDateTimestamp }
    }
}
