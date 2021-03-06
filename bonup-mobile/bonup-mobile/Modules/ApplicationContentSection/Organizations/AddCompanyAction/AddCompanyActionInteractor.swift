//
//  AddCompanyActionInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 25.04.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol IAddCompanyActionInteractor: AnyObject {

    var viewModels: [AddCompanyActionViewModel] { get }
    var selectedCategory: InterestCategories { get set }
    var selectedPhoto: UIImage { get set }
    var actionType: CompanyActionType { get }
    var mode: AddCompanyActionDependency.Mode { get }
    var usesCount: Int { get }
    var initAction: OrganizationActionEntity? { get }
    
    func updateValue(_ value: Any, at index: Int)
    func addAction(success:((String) -> Void)?, failure:((String) -> Void)?)
}

final class AddCompanyActionInteractor {

    // MARK: - Services
    
    private lazy var controlNetworkProvider = MainNetworkProvider<OrganizationControlService>()
    private lazy var photosNetworkProvider = MainNetworkProvider<PhotosService>()
    
    // MARK: - Private properties
    
    private var _viewModels: [AddCompanyActionViewModel]
    internal let organizationId: String
    
    // MARK: - Public properties
    
    var actionType: CompanyActionType
    var mode: AddCompanyActionDependency.Mode = .create
    var selectedCategory: InterestCategories = .food
    var selectedPhoto: UIImage = AssetsHelper.shared.image(.addImageIcon)!
    var initAction: OrganizationActionEntity?
    
    // MARK: - Initialization

    init(actionType: CompanyActionType,
         organizationId: String,
         action: OrganizationActionEntity?,
         mode: AddCompanyActionDependency.Mode) {
        
        self.mode = mode
        self.actionType = actionType
        self.organizationId = organizationId
        self.initAction = action
        
        if let action = action {
         
            self.selectedCategory = InterestCategories.category(id: action.categoryId)
        }
        else {
            
            self.selectedCategory = .food
        }
        
        switch actionType {
        
        case .task, .coupon:
            _viewModels = [
                
                AddCompanyActionViewModel(with: action?.title ?? "",
                                          field: .title,
                                          mode: mode),
                AddCompanyActionViewModel(with: action?.descriptionText ?? "",
                                          field: .description,
                                          mode: mode),
                AddCompanyActionViewModel(with: String(action?.bonusesCount ?? 0),
                                          field: .bonuses,
                                          mode: mode),
                AddCompanyActionViewModel(with: String(action?.allowedCount ?? 0),
                                          field: .allowedCount,
                                          mode: mode),
                AddCompanyActionViewModel(with: Date.dateFromTimestamp(action?.startDateTimestamp ?? Date().timestamp),
                                          field: .startDate,
                                          mode: mode),
                AddCompanyActionViewModel(with: Date.dateFromTimestamp(action?.endDateTimestamp ?? Date().timestamp),
                                          field: .endDate,
                                          mode: mode)
            ]
            
        case .stock:
            _viewModels = [
                
                AddCompanyActionViewModel(with: action?.title ?? "",
                                          field: .title,
                                          mode: mode),
                AddCompanyActionViewModel(with: action?.descriptionText ?? "",
                                          field: .description,
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
    
    var usesCount: Int {
        
        return self.initAction?.triggeredCount ?? 0
    }
    
    func updateValue(_ value: Any, at index: Int) {
        
        self._viewModels[index].value = value
    }
    
    func addAction(success:((String) -> Void)?, failure:((String) -> Void)?) {
        
        DispatchQueue.global(qos: .background).async {
         
            guard let token = AccountManager.shared.currentToken else { return }
            
            var requestEntity = OrganizationActionEntity()
            
            requestEntity.categoryId = self.selectedCategory.rawValue
            requestEntity.organizationName = self.organizationId
            
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
                    requestEntity.bonusesCount = Int(viewModel.value as? String ?? "-") ?? 0
                    
                case .allowedCount:
                    requestEntity.allowedCount = Int(viewModel.value as? String ?? "-") ?? 0
                    
                }
            }
            
            _ = self.photosNetworkProvider
                .request(.uploadPhoto(self.selectedPhoto),
                         type: PhotoResponseEntity.self,
                         completion: { [weak self] result in
                            
                            requestEntity.photoId = Int(result.message) ?? 0
                            
                            guard let actionType = self?.actionType else { return }
                            
                            let target: OrganizationControlService
                            
                            switch actionType {
                            
                            case .task:
                                target = .putTask(token, requestEntity)
                                
                            case .coupon:
                                target = .putCoupon(token, requestEntity)
                                
                            case .stock:
                                target = .putStock(token, requestEntity)
                            }
                            
                            _ = self?.controlNetworkProvider.request(
                                target,
                                type: OrganizationControlAppendResponseEntity.self,
                                completion: { result in
                                    
                                    if result.isSuccess {
                                        
                                        success?("ui_successfully_added_message".localized)
                                    } else {
                                        
                                        failure?(result.message)
                                    }
                                },
                                failure: { err in
                                    
                                    failure?(err?.localizedDescription ?? "ui_error_title".localized)
                                }
                            )
                         },
                         failure: { err in
                            
                            failure?(err?.localizedDescription ?? "ui_error_title".localized)
                         })
        }
    }
    
    // MARK: - Private
    
    private func validationError(_ rowType: CompanyActionFieldType) -> String {
        
        return "\(rowType.title.localized) \("ui_validation_faild".localized)"
    }
}
