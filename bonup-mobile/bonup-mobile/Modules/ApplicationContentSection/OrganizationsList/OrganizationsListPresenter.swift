//
//  OrganizationsListPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IOrganizationsListPresenter: AnyObject {

    func refreshData()
    func title(for index: Int) -> String
    func imagePath(for index: Int) -> String
    func numberOfOrganizations() -> Int
    func handleShowOgranizationControl(for index: Int)

    func handleAddButtonTap()
}

final class OrganizationsListPresenter {

    // MARK: - Private variables
    
    private weak var view: IOrganizationsListView?
    private let interactor: IOrganizationsListInteractor
    private let router: IOrganizationsListRouter

    // MARK: - Data variables
    
    private var organizationsResponse: OrganizationsListResponseEntity?

    // MARK: - State variables
    
    private var isFirstRefresh = true
    
    // MARK: - Init
    
    init(view: IOrganizationsListView?,
         interactor: IOrganizationsListInteractor,
         router: IOrganizationsListRouter) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IBenefitsPresenter implementation

extension OrganizationsListPresenter: IOrganizationsListPresenter {
    
    func title(for index: Int) -> String {

        guard let response = self.organizationsResponse else { return "-" }

        return response.organizations[index].name
    }

    func imagePath(for index: Int) -> String {

        guard let response = self.organizationsResponse else { return "" }

        return response.organizations[index].photo
    }

    func handleShowOgranizationControl(for index: Int) {

        guard let response = self.organizationsResponse else { return }

        self.router.show(.showOrganizationControl(response.organizations[index].name))
    }

    func numberOfOrganizations() -> Int {

        guard let response = self.organizationsResponse else { return 0 }

        return response.organizations.count
    }

    func refreshData() {

        if self.isFirstRefresh {
            
            self.isFirstRefresh.toggle()
        }
        
        self.interactor.getOrganizationsList(
            withLoader: self.isFirstRefresh,
            success: { [weak self] entity in

                self?.organizationsResponse = entity
                
                DispatchQueue.main.async {
                    
                    self?.view?.stopRefreshControl()
                    self?.view?.reloadData()
                }
            },
            failure: { [weak self] status, message in

                DispatchQueue.main.async {
                
                    self?.view?.stopRefreshControl()
                }
            }
        )
    }

    func handleAddButtonTap() {

        self.router.show(.showAddNewOrganization)
    }
}
