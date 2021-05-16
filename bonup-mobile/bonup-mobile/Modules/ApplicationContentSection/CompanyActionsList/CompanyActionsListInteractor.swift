//
//  CompanyActionsListInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyActionsListInteractor: AnyObject {
    
    var actionsList: [OrganizationControlAppendRequestEntity]? { get }
    var currentMode: CompanyActionsListDependency.Mode { get }
}

final class CompanyActionsListInteractor {
    
    // MARK: - Init
    
    init(actions: [OrganizationControlAppendRequestEntity]?,
         mode: CompanyActionsListDependency.Mode) {
        
        self.actionsList = actions
        self.currentMode = mode
    }
    
    // MARK: - Public variables
    
    var actionsList: [OrganizationControlAppendRequestEntity]?
    var currentMode: CompanyActionsListDependency.Mode
}

// MARK: - CompanyActionsListInteractor

extension CompanyActionsListInteractor: ICompanyActionsListInteractor { }
