//
//  CompanyActionsAggregatorInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyActionsAggregatorInteractor: AnyObject {

    var companyName: String { get }
}

final class CompanyActionsAggregatorInteractor {

    // MARK: - Public variables
    
    var companyName: String
    
    // MARK: - Init
    
    init(companyName: String) {
        
        self.companyName = companyName
    }
}

// MARK: - ISettingsInteractor implementation

extension CompanyActionsAggregatorInteractor: ICompanyActionsAggregatorInteractor { }
