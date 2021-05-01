//
//  AddCompanyActionInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 25.04.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IAddCompanyActionInteractor: AnyObject {

    var viewModels: [AddCompanyActionViewModel] { get }
    var categoriesIds: [Int] { get set }
    var actionType: CompanyActionType { get }
    
    func updateValue(_ value: Any, at index: Int)
    func handleAddAction(success:((String) -> Void)?, failure:((String) -> Void)?)
}

final class AddCompanyActionInteractor {

    // MARK: - Private properties
    
    private let networkProvider = MainNetworkProvider<OrganizationControlService>()
    private var _viewModels: [AddCompanyActionViewModel]
    internal var categoriesIds: [Int]
    internal let organizationId: String
    
    // MARK: - Public properties
    
    var actionType: CompanyActionType
    
    // MARK: - Initialization

    init(actionType: CompanyActionType, organizationId: String) {
        
        // NOTE: - In the future list of fields may be changed
        switch actionType {
        case .task:
            _viewModels = [
                AddCompanyActionViewModel(fieldType: .title, value: ""),
                AddCompanyActionViewModel(fieldType: .description, value: ""),
                AddCompanyActionViewModel(fieldType: .bonuses, value: 0),
                AddCompanyActionViewModel(fieldType: .startDate, value: Date()),
                AddCompanyActionViewModel(fieldType: .endDate, value: Date())
            ]
            
        case .coupon:
            _viewModels = [
                AddCompanyActionViewModel(fieldType: .title, value: ""),
                AddCompanyActionViewModel(fieldType: .description, value: ""),
                AddCompanyActionViewModel(fieldType: .bonuses, value: 0),
                AddCompanyActionViewModel(fieldType: .startDate, value: Date()),
                AddCompanyActionViewModel(fieldType: .endDate, value: Date())
            ]
        }
        
        self.categoriesIds = []
        self.actionType = actionType
        self.organizationId = organizationId
    }
}

// MARK: - IAddCompanyInteractor implementation

extension AddCompanyActionInteractor: IAddCompanyActionInteractor {

    var viewModels: [AddCompanyActionViewModel] {

        return self._viewModels
    }
    
    func updateValue(_ value: Any, at index: Int) {
        
        self._viewModels[index].value = value
    }
    
    func handleAddAction(success:((String) -> Void)?, failure:((String) -> Void)?) {
        
        var requestEntity = OrganizationControlAppendRequestEntity()
        
        guard let token = AccountManager.shared.currentToken else { return }
        
        requestEntity.token = token
        
        for viewModel in _viewModels {
            
            switch viewModel.fieldType {
            case .title:
                requestEntity.title = viewModel.value as? String ?? ""
                
            case .description:
                requestEntity.descriptionText = viewModel.value as? String ?? ""
                
            case .startDate:
                requestEntity.startDateTimestamp = (viewModel.value as? Date ?? Date()).timestamp
                
            case .endDate:
                requestEntity.endDateTimestamp = (viewModel.value as? Date ?? Date()).timestamp
                
            case .bonuses:
                requestEntity.bonusesCount = viewModel.value as? Int ?? 0
                
            }
        }
        
        let target: OrganizationControlService = self.actionType == .coupon ? .putCoupon(requestEntity) : .putTask(requestEntity)
        
        _ = networkProvider.request(
            target,
            type: OrganizationControlAppendResponseEntity.self,
            completion: { result in
                if result.isSuccess {
                    success?(result.message)
                } else {
                    failure?(result.message)
                }
            },
            failure: { err in
                failure?(err?.localizedDescription ?? "")
            }
        )
    }
}
