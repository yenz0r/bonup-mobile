//
//  DataBaseProvider.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IDataBaseProvider {
    
    var authorizationProvider: RealmProvider<AuthorizationRealm> {get}
    
    func didEnterBackground()
}

class DataBaseProvider {
    
    // MARK: - Private constants
    
    private var _authorizationProvider: RealmProvider<AuthorizationRealm>?
    
    // MARK: - Internal properties
    
    var authorizationProvider: RealmProvider<AuthorizationRealm> {
        
        guard let provider = _authorizationProvider else {
            
            let provider = RealmProvider<AuthorizationRealm>()
            _authorizationProvider = provider
            
            return provider
        }
        
        return provider
    }
    
    // MARK: - Initialization
    
    init() { }
}

extension DataBaseProvider: IDataBaseProvider {
    
    func didEnterBackground() {
        
        _authorizationProvider?.didEnterBackground(failure: nil)
    }
}
