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
    var selectedCategory: InterestCategories { get set }
    var actionType: CompanyActionType { get }
    var mode: AddCompanyActionDependency.Mode { get }
    
    func updateValue(_ value: Any, at index: Int)
    func handleAddAction(success:((String) -> Void)?, failure:((String) -> Void)?)
}

final class AddCompanyActionInteractor {

    // MARK: - Private properties
    
    private let networkProvider = MainNetworkProvider<OrganizationControlService>()
    private var _viewModels: [AddCompanyActionViewModel]
    internal let organizationId: String
    
    // MARK: - Public properties
    
    var actionType: CompanyActionType
    var mode: AddCompanyActionDependency.Mode = .create
    var selectedCategory: InterestCategories = .food
    
    // MARK: - Initialization

    init(actionType: CompanyActionType,
         organizationId: String,
         action: OrganizationControlAppendRequestEntity?,
         mode: AddCompanyActionDependency.Mode) {
        
        self.mode = mode
        self.actionType = actionType
        self.organizationId = organizationId
        
        // NOTE: - In the future list of fields may be changed
        switch actionType {
        
        case .task, .coupon:
            _viewModels = [
                
                AddCompanyActionViewModel(with: action?.title ?? "",
                                          field: .title,
                                          mode: mode),
                AddCompanyActionViewModel(with: action?.descriptionText ?? "",
                                          field: .description,
                                          mode: mode),
                AddCompanyActionViewModel(with: action?.bonusesCount ?? 0,
                                          field: .bonuses,
                                          mode: mode),
                AddCompanyActionViewModel(with: action?.allowedCount ?? 0,
                                          field: .allowedCount,
                                          mode: mode),
                AddCompanyActionViewModel(with: Date.dateFromTimestamp(action?.startDateTimestamp ?? Date().timestamp),
                                          field: .startDate,
                                          mode: mode),
                AddCompanyActionViewModel(with: Date.dateFromTimestamp(action?.endDateTimestamp ?? Date().timestamp),
                                          field: .endDate,
                                          mode: mode)
            ]
        }
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
        
        DispatchQueue.global(qos: .background).async {
         
            guard let token = AccountManager.shared.currentToken else { return }
            
            var requestEntity = OrganizationControlAppendRequestEntity()
            
            requestEntity.categoryId = self.selectedCategory.rawValue
            
            for viewModel in self._viewModels {
                
                switch viewModel.fieldType {
                case .title:
                    
                    guard let string = viewModel.value as? String, string != "" else {
                        
                        failure?(self.validationError(.title))
                        return
                    }
                    
                    requestEntity.title = string
                    
                case .description:
                    
                    guard let string = viewModel.value as? String, string != "" else {
                        
                        failure?(self.validationError(.description))
                        return
                    }
                    
                    requestEntity.descriptionText = string
                    
                case .startDate:
                    requestEntity.startDateTimestamp = (viewModel.value as? Date ?? Date()).timestamp
                    
                case .endDate:
                    requestEntity.endDateTimestamp = (viewModel.value as? Date ?? Date()).timestamp
                    
                case .bonuses:
                    requestEntity.bonusesCount = viewModel.value as? Int ?? 0
                    
                case .allowedCount:
                    requestEntity.allowedCount = viewModel.value as? Int ?? 0
                    
                }
            }
            
            let target: OrganizationControlService = self.actionType == .coupon ? .putCoupon(token, requestEntity) : .putTask(token, requestEntity)
            
            _ = self.networkProvider.request(
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
    
    // MARK: - Private
    
    private func validationError(_ rowType: CompanyActionFieldType) -> String {
        
        return "\(rowType.title.localized) \("ui_validation_faild".localized)"
    }
}
