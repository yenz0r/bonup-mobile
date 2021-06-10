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
    
    func filteredActions() -> (labels: [String], statistics: [CompanyActionsStatisticsEntity])
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
    
    private var tasksStats: [Date : CompanyActionsStatisticsEntity] = [:]
    private var couponsStats: [Date: CompanyActionsStatisticsEntity] = [:]
    
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
                
                result.tasks.forEach { key, value in
                    
                    self?.tasksStats[Date.dateFromTimestamp(key)] = value
                }
                
                result.coupons.forEach { key, value in
                    
                    self?.couponsStats[Date.dateFromTimestamp(key)] = value
                }
                
                success?()
            },
            failure: { err in
                
                failure?(err?.localizedDescription ?? "ui_error_title".localized)
            })
    }
    
    func filteredActions() -> (labels: [String], statistics: [CompanyActionsStatisticsEntity]) {
        
        var stats: [Date: CompanyActionsStatisticsEntity]
        
        switch self.selectedInfoType {
        case .tasks:
            stats = self.tasksStats
            
        case .coupons:
            stats = self.couponsStats
        }
        
        let dates = stats
            .keys
            .filter { $0 <= self.periodToDate &&
                      $0 >= self.periodFromDate }
            .sorted(by: >)
        
        var statistics = [CompanyActionsStatisticsEntity]()
        var labels = [String]()
        
        for date in dates {
            
            let dateString = Date.dateFormatter.string(from: date)
            let statEl = stats[date] ?? CompanyActionsStatisticsEntity(actions: [], count: 0)
            
            labels.append(dateString)
            statistics.append(statEl)
        }
        
        return (labels, statistics)
    }
}
