//
//  CompanyStatisticsInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 2.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyStatisticsInteractor: AnyObject {

    var selectedCategoriesId: [Int] { get set }
    
    var selectedPeriod: CompanyStatisticsPeriod { get }
    var periods: [CompanyStatisticsPeriod] { get }
    
    func updateSelectedPeriod(at index: Int)
}

final class CompanyStatisticsInteractor {

    // MARK: - Private variables

    var selectedCategoriesId = [Int]()
    var selectedPeriod = CompanyStatisticsPeriod.week
    private var companyId: String
    
    // MARK: - Init
    
    init(companyId: String) {
        
        self.companyId = companyId
    }
}

// MARK: - ICompanyStatisticsInteractor implementation

extension CompanyStatisticsInteractor: ICompanyStatisticsInteractor {
 
    var periods: [CompanyStatisticsPeriod] {
        
        return CompanyStatisticsPeriod.allCases
    }
    
    func updateSelectedPeriod(at index: Int) {
        
        self.selectedPeriod = self.periods[index]
    }
}
