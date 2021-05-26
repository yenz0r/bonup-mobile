//
//  ProfileInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 20.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IProfileInteractor: AnyObject {

    func getUserInfo(withLoader: Bool, success: (() -> Void)?, failure: ((String) -> Void)?)
    func stats(for category: ProfileActionsChartsContainer.Category) -> [InterestCategories: [OrganizationActionEntity]]?
    
    var profileName: String? { get }
    var profileEmail: String? { get }
    var profileOrganizationName: String? { get }
    var profileAvatarId: Int? { get }

    var profileCurrentBallsCount: Int? { get }
    var profileTasksCount: Int? { get }
    var profileSpentBallsCount: Int? { get }
    
    var goals: [ProfileGoalsResponse]? { get }
}

final class ProfileInteractor {

    // MARK: - Private variables
    
    private lazy var networkProvider = MainNetworkProvider<ProfileService>()
    private var profileDataModel: ProfileResponseDetailsEntity?
}

// MARK: - IChangePasswordInteractor implementation

extension ProfileInteractor: IProfileInteractor {
    
    var profileName: String? { self.profileDataModel?.name }
    var profileEmail: String? { self.profileDataModel?.email }
    var profileOrganizationName: String? { self.profileDataModel?.organizationName }
    var profileAvatarId: Int? { self.profileDataModel?.photoId }
    
    var profileCurrentBallsCount: Int? { self.profileDataModel?.balls }
    var profileTasksCount: Int? { self.profileDataModel?.tasksNumber }
    var profileSpentBallsCount: Int? { self.profileDataModel?.spentBalls }
    
    var goals: [ProfileGoalsResponse]? { self.profileDataModel?.goals }
    
    func stats(for category: ProfileActionsChartsContainer.Category) -> [InterestCategories: [OrganizationActionEntity]]? {
        
        guard let profileDataModel = self.profileDataModel else { return nil }
        
        var actions: [OrganizationActionEntity]
        
        switch category {
        
        case .tasks:
            actions = profileDataModel.finishedTasks
            
        case .coupons:
            actions = profileDataModel.finishedCoupons
        }
        
        var result: [InterestCategories: [OrganizationActionEntity]] = [:]
        
        for category in InterestCategories.allCases {
            
            let categoryActions = actions.filter { $0.categoryId == category.rawValue }
            
            if categoryActions.count != 0 {
                
                result[category] = categoryActions
            }
        }
        
        return result
    }

    func getUserInfo(withLoader: Bool,
                     success: (() -> Void)?,
                     failure: ((String) -> Void)?) {

        guard let token = AccountManager.shared.currentToken else { return }

        _ = networkProvider.request(
            .getUsetData(token),
            type: ProfileResponseEntity.self,
            withLoader: withLoader,
            completion: { [weak self] result in
                
                if result.isSuccess {

                    self?.profileDataModel = result.userInfo
                    success?()
                }
                else {

                    failure?(result.message)
                }
            },
            failure: { err in
                
                failure?(err?.localizedDescription ?? "")
            }
        )
    }
}
