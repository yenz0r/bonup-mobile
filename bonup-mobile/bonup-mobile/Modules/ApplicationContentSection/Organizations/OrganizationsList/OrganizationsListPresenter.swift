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
    func imagePath(for index: Int) -> URL?
    func numberOfOrganizations() -> Int
    func handleShowOgranizationControl(for index: Int)

    func handleAddButtonTap()
}

final class OrganizationsListPresenter {

    // MARK: - Private variables
    
    private weak var view: IOrganizationsListView?
    private let interactor: IOrganizationsListInteractor
    private let router: IOrganizationsListRouter

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

        return self.interactor.companies?[index].title ?? "-"
    }

    func imagePath(for index: Int) -> URL? {

        return PhotosService.photoURL(for: self.interactor.companies?[index].photoId)
    }

    func handleShowOgranizationControl(for index: Int) {

        guard let company = self.interactor.companies?[index] else { return }

        self.router.show(.showOrganizationControl(company))
    }

    func numberOfOrganizations() -> Int {

        return self.interactor.companies?.count ?? 0
    }

    func refreshData() {
        
        self.interactor.getOrganizationsList(
            withLoader: self.isFirstRefresh,
            success: { [weak self] in
                
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
        
        if self.isFirstRefresh {
            
            self.isFirstRefresh.toggle()
        }
    }

    func handleAddButtonTap() {

        self.router.show(.showAddNewOrganization(onStop: { [weak self] in
            
            self?.isFirstRefresh = true
            self?.refreshData()
        }))
    }
}
