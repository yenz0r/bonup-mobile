//
//  AccountsCredsPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IAccountsCredsPresenter: AnyObject {
    
    func viewDidLoad()
    
    var accountsCreds: [AuthCredRealmObject] { get }
    
    func deleteItem(at index: Int)
    func delegeAllItems()
    
    func handleItemSelection(at index: Int)
}

final class AccountsCredsPresenter {

    // MARK: - Private variables

    private weak var view: IAccountsCredsView?
    private let interactor: IAccountsCredsInteractor
    private let router: IAccountsCredsRouter

    // MARK: - Init

    init(view: IAccountsCredsView?, interactor: IAccountsCredsInteractor, router: IAccountsCredsRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICompanySearchPresenter

extension AccountsCredsPresenter: IAccountsCredsPresenter {
    
    func deleteItem(at index: Int) {
        
        self.interactor.deleteItem(at: index)
    }
    
    func delegeAllItems() {
        
        self.interactor.deleteAllItems()
        self.view?.reloadData()
    }
    
    var accountsCreds: [AuthCredRealmObject] {
        
        return self.interactor.accountsCreds
    }
    
    func viewDidLoad() {
        
        self.interactor.loadData { [weak self] in
        
            self?.view?.reloadData()
        }
    }
    
    func handleItemSelection(at index: Int) {
        
        self.router.stop(self.interactor.accountsCreds[index])
    }
}
