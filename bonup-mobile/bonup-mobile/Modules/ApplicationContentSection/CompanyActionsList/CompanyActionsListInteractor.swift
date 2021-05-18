//
//  CompanyActionsListInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyActionsListInteractor: AnyObject {
    
    var actionsList: [OrganizationActionEntity] { get }
    var contentType: CompanyActionsListDependency.ContentType { get }
    var contentMode: CompanyActionsListDependency.ContentMode { get }
    
    func loadActions(companyName: String, completion: @escaping (Bool) -> Void)
}

final class CompanyActionsListInteractor {
    
    // MARK: - Init
    
    init(actions: [OrganizationActionEntity]?,
         contentType: CompanyActionsListDependency.ContentType,
         contentMode: CompanyActionsListDependency.ContentMode) {
        
        self.actionsList = actions ?? []
        self.contentType = contentType
        self.contentMode = contentMode
    }
    
    // MARK: - Private variables
    
    private lazy var actionsNetworkProvider = MainNetworkProvider<OrganizationActionsService>()
    
    // MARK: - Public variables
    
    var actionsList: [OrganizationActionEntity]
    var contentType: CompanyActionsListDependency.ContentType
    var contentMode: CompanyActionsListDependency.ContentMode
}

// MARK: - CompanyActionsListInteractor

extension CompanyActionsListInteractor: ICompanyActionsListInteractor {
    
    func loadActions(companyName: String, completion: @escaping (Bool) -> Void) {
      
        guard let token = AccountManager.shared.currentToken else {
            
            completion(false)
            return
        }
        
        var target: OrganizationActionsService
        
        switch self.contentType {
        
        case .coupons:
            target = .getCoupons(token: token, companyName: companyName)
            
        case .tasks:
            target = .getTasks(token: token, companyName: companyName)
            
        case .stocks:
            target = .getStocks(token: token, companyName: companyName)
        }
        
        _ = self.actionsNetworkProvider
            .request(target,
                     type: [OrganizationActionEntity].self,
                     completion: { [weak self] result in
                        
                        self?.actionsList = result
                        
                        completion(true)
                     },
                     failure: { _ in
                        
                        completion(false)
                     })
    }
}
