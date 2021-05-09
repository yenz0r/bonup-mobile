//
//  IRealmProvider.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

typealias ErrorHandler = ((_ error : Swift.Error) -> Void)
typealias ObjectsResolvedHandler = (IRealmProvider?, ThreadSafeReference<Results<Object>>) -> Void

protocol IRealmObservation {
    
    func realmObservation()
    func realmObservationInvalidation()
}

protocol IRealmProvider {
    
    func resolve<T: ThreadConfined>(_ wrapped: ThreadSafeReference<T>) -> T?
    
    func read(type: Object.Type,
              completion: ObjectsResolvedHandler?,
              failure: ErrorHandler?)
    
    func write<Element: Object>(element: Element,
                                failure: ErrorHandler?)
    
    func overwrite<Element: Object>(element: Element,
                                    failure: ErrorHandler?)
    
    func delete<Element: Object>(element: Element,
                                 failure: ErrorHandler?)
    func delete<Element: Object>(elements: Results<Element>,
                                 failure: ErrorHandler?)
    
    func deleteAll(failure: ErrorHandler?)
    
    func didEnterBackground(failure: ErrorHandler?)
}

protocol IBURealm {
    
    init()
    
    var workingQueue: DispatchQueue? { get }
    var fileName: String {get}
    var realmTypes: [Object.Type] {get}
    
    func realmType(type: AnyClass?) -> Object.Type
    func maxRecords(type: AnyClass?) -> Int
    func sortingSettings(type: AnyClass?) -> (String, Bool)?
    
    var realmVersion: UInt64 {get}
    var migrationBlock: MigrationBlock? {get}
}

