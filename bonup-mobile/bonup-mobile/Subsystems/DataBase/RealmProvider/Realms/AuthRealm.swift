//
//  AuthRealm.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import RealmSwift

class AuthorizationRealm: IBURealm {
    
    // MARK: - Internal variables
    
    var workingQueue: DispatchQueue? = DispatchQueue(label: "com.bonup.realm.authorization.entities.queue",
                                                     qos: .userInteractive,
                                                     attributes: .concurrent,
                                                     autoreleaseFrequency: .workItem,
                                                     target: DispatchQueue.global(qos: .userInteractive))
    var fileName: String = "Authorization.realm"
    var realmTypes: [Object.Type] = [AuthCredRealmObject.self]
    
    // MARK: - Initialization
    
    required init() {}
    
    // MARK: - Max records
    
    func maxRecords(type: AnyClass?) -> Int {
        
        switch type.self {
            
        case is AuthCredRealmObject.Type:
            return 50
            
        default:
            return 0
        }
    }
    
    // MARK: - Realm Type

    func realmType(type: AnyClass?) -> Object.Type {
        
        switch type.self {
            
        case is AuthCredRealmObject.Type:
            return AuthCredRealmObject.self
            
        default:
            return Object.self
        }
    }
    
    // MARK: - Sorting settings
    
    func sortingSettings(type: AnyClass?) -> (String, Bool)? {
        
        switch type.self {
            
        case is AuthCredRealmObject.Type:
            return nil
            
        default:
            return nil
        }
    }
    
    // MARK: - Migration
    
    var realmVersion: UInt64 {
        return 1
    }
    
    var migrationBlock: MigrationBlock? 
}

