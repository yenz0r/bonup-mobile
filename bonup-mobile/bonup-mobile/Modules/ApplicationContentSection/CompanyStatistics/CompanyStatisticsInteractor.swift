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
    
    // MARK: - Init
    
    init(companyId: String) {
        
        self.companyId = companyId
    }
}

// MARK: - ICompanyStatisticsInteractor implementation

extension CompanyStatisticsInteractor: ICompanyStatisticsInteractor {
 
    
}
