//
//  AccountsCredsInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IAccountsCredsInteractor: AnyObject {

    var accountsCreds: [AuthCredRealmObject] { get }
    
    func loadData(completion: (() -> Void)?)
    
    func deleteItem(at index: Int)
    func deleteAllItems()
}

final class AccountsCredsInteractor {

    // MARK: - Private variables

    private lazy var storageProvider = DataBaseProvider().authorizationProvider
    private var _accountsCreds = [AuthCredRealmObject]()
}

// MARK: - ICompanyPacketInteractor implementation

extension AccountsCredsInteractor: IAccountsCredsInteractor {
    
    func deleteItem(at index: Int) {
        
        let item = self._accountsCreds.remove(at: index)
        
        self.storageProvider.delete(element: item, failure: nil)
    }
    
    func deleteAllItems() {
        
        for item in self._accountsCreds {
            
            self.storageProvider.delete(element: item, failure: nil)
        }
        
        self._accountsCreds.removeAll()
    }
    
    func loadData(completion: (() -> Void)?) {
        
        self.storageProvider.read(
            type: AuthCredRealmObject.self,
            completion: { [weak self] realm, results in
                
                DispatchQueue.main.async { [weak self] in
                    
                    if let resolvedResults = realm?.resolve(results) {
                        
                        self?._accountsCreds = resolvedResults.compactMap { $0 as? AuthCredRealmObject }
                    }
                    
                    completion?()
                }
            },
            failure: nil
        )
    }
    
    var accountsCreds: [AuthCredRealmObject] {
        
        return self._accountsCreds
    }
}
