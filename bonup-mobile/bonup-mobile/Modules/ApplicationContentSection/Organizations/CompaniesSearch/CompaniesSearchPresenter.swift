//
//  CompanySearchPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompaniesSearchPresenter: AnyObject {
    
    func refreshData()
    
    func handleCategoriesUpdate(categories: [InterestCategories])
    func handleSearchValueUpdate(_ searchText: String?)
    func handleCompanySelection(_ companyTitle: String)
    
    func companies() -> [CompanyEntity]
    func userLocation() -> (latitude: Double, longitude: Double)?
}

final class CompaniesSearchPresenter {

    // MARK: - Private variables

    private weak var view: ICompaniesSearchView?
    private let interactor: ICompaniesSearchInteractor
    private let router: ICompaniesSearchRouter

    // MARK: - State variables
    
    private var isFirstRefresh = true
    
    // MARK: - Init

    init(view: ICompaniesSearchView?, interactor: ICompaniesSearchInteractor, router: ICompaniesSearchRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICompanySearchPresenter

extension CompaniesSearchPresenter: ICompaniesSearchPresenter {
    
    func userLocation() -> (latitude: Double, longitude: Double)? {
        
        return self.interactor.userLocation
    }
    
    func companies() -> [CompanyEntity] {
        
        return self.interactor.organizations
    }

    func refreshData() {
        
        if self.interactor.organizations.isEmpty {
            
            self.interactor.loadOrganizations(withLoader: self.isFirstRefresh) { [weak self] success in
                
                DispatchQueue.main.async {
                 
                    if success {
                        
                        self?.view?.reloadMap()
                    }
                    else {
                        
                        self?.router.show(.showErrorAlert)
                    }
                }
            }
        }
        
        if self.isFirstRefresh {
            
            self.isFirstRefresh.toggle()
        }
    }
    
    func handleCategoriesUpdate(categories: [InterestCategories]) {
        
        let prev = self.interactor.organizations
        
        self.interactor.selectedCategories = categories
        
        if self.uiShouldBeReloaded(prev: prev, new: self.interactor.organizations) {
        
            self.view?.reloadMap()
        }
    }
    
    func handleSearchValueUpdate(_ searchText: String?) {
        
        let prev = self.interactor.organizations
        
        self.interactor.searchText = searchText
        
        if self.uiShouldBeReloaded(prev: prev, new: self.interactor.organizations) {
        
            self.view?.reloadMap()
        }
    }
    
    func handleCompanySelection(_ companyTitle: String) {
        
        guard let company = self.interactor.organizations.first(where: { $0.title == companyTitle }) else {
            
            return
        }
        
        self.router.show(.showCompanyDescription(company))
    }
    
    private func uiShouldBeReloaded(prev: [CompanyEntity], new: [CompanyEntity]) -> Bool {
        
        let newTitles = new.map { $0.title }
        let prevTitles = prev.map { $0.title }
        
        return prevTitles != newTitles
    }
}
