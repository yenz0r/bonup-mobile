//
//  CompanyStatisticsInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 2.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import UIKit

protocol ICompanyStatisticsInteractor: AnyObject {

    var selectedInfoType: CompanyStatisticsInteractor.InfoType { get set }
    var selectedCategoriesId: [Int] { get set }
    var periodFromDate: Date { get set }
    var periodToDate: Date { get set }
    
    func loadStats(success: (() -> Void)?,
                   failure: ((String) -> Void)?)
    
    func filteredActions() -> (labels: [String], actions: [[OrganizationActionEntity]])
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
        
        var gradientForChart: CGGradient {
            
            var color: UIColor
            
            switch self {
            
            case .tasks:
                color = .cyan
                
            case .coupons:
                color = .orange
            }
            
            let gradientColors = [color.cgColor, UIColor.clear.cgColor] as CFArray
            let colorLocations:[CGFloat] = [1.0, 0.0]
            return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                   colors: gradientColors,
                                   locations: colorLocations)!
        }
    }
    
    // MARK: - Public variables
    
    var selectedInfoType: CompanyStatisticsInteractor.InfoType = .tasks
    var selectedCategoriesId = InterestCategories.allCases.map { $0.rawValue }
    var periodFromDate: Date = Date().withDaysOffset(-7)
    var periodToDate: Date = Date()
    
    // MARK: - Private variables

    private var companyId: String
    private lazy var statsNetworkProvider = MainNetworkProvider<CompanyStatisticsService>()
    private var statsEntity: CompanyStatisticsEntity?
    
    // MARK: - Init
    
    init(companyId: String) {
        
        self.companyId = companyId
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
    
    func filteredActions() -> (labels: [String], actions: [[OrganizationActionEntity]]) {
        
        guard let stats = self.statsEntity else { return ([], []) }
        
        var actions: [OrganizationActionEntity]
        
        switch self.selectedInfoType {
        case .tasks:
            actions = stats.tasks
            
        case .coupons:
            actions = stats.coupons
        }
        
        actions = actions
            .filter { self.selectedCategoriesId.contains($0.categoryId) &&
                      $0.endDateTimestamp <= self.periodToDate.timestamp &&
                      $0.startDateTimestamp >= self.periodFromDate.timestamp }
        
        var startDate = self.periodFromDate
        let endDate = self.periodToDate
        
        var resultActions = [[OrganizationActionEntity]]()
        var resultDates = [String]()
        
        while startDate <= endDate {
            
            let selectedDateActions = actions.filter {
                
                Date.isEqual(firstDate: Date.dateFromTimestamp($0.startDateTimestamp),
                             secondDate: startDate,
                             by: [.year, .month, .day])
            }
            
            resultActions.append(selectedDateActions)
            resultDates.append(Date.dateFormatter.string(from: startDate))
            
            startDate = startDate.withDaysOffset(1)
        }
        
        return (resultDates, resultActions)
    }
}
