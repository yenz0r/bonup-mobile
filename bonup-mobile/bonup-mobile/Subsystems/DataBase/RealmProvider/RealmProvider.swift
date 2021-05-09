//
//  RealmProvider.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProvider<BURealm: IBURealm> {
    
    // MARK: - Private constants
    
    private let buRealm: BURealm = BURealm()
    
    private let workingQueue: DispatchQueue
    private let lockerQueue = DispatchQueue(label: "com.bonup.realm.locker.queue")
    
    // MARK: - Private variables
    
    private var configuration: Realm.Configuration?
    private var resultsDictionary = [String : ThreadSafeReference<Results<Object>>]()
    
    // MARK: - Private properties
    
    private var privateContextRealm: Realm? {
        
        do {
            
            guard let config = configuration else {
                return nil
            }
            
            let realm = try Realm(configuration: config)
            realm.refresh()
            realm.autorefresh = true
            
            return realm
            
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    }
    
    // MARK: - Initialization
    
    init() {
        
        if let queue = buRealm.workingQueue {
            
            workingQueue = queue
            
        } else {
            
            workingQueue = DispatchQueue(label: "com.ewallet.realm.working.queue",
                                         qos: .default,
                                         attributes: .concurrent,
                                         autoreleaseFrequency: .workItem,
                                         target: DispatchQueue.global(qos: .default))
        }
        
        configureRealm()
    }
    
    // MARK: - Private functions
    
    private func configureRealm() {
        
        var documentDirectory: URL?
        do {
            
            documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false)
        } catch let error as NSError {
            print(error)
        }
        
        self.configuration = Realm.Configuration(
            fileURL: documentDirectory?.appendingPathComponent(buRealm.fileName),
            schemaVersion: buRealm.realmVersion,
            migrationBlock: buRealm.migrationBlock,
            objectTypes: buRealm.realmTypes
        )
    }
    
    // MARK: - Private functions
    
    private func resultsDidUpdated(with type: Object.Type, entities: Results<Object>) {
        
        let key = NSStringFromClass(type.self)
        let reference = ThreadSafeReference(to: entities)
        
        lockerQueue.sync { [weak self] in
            
            self?.resultsDictionary[key] = reference
        }
    }
    
    private func sort(results: Results<Object>) -> Results<Object> {
        
        let typeOf = type(of: results)
        if let (keyPath, ascending) = buRealm.sortingSettings(type: typeOf.ElementType.self) {
            
            return results.sorted(byKeyPath: keyPath,
                                  ascending: ascending)
        } else {

            return results
        }
    }
    
    // MARK: - Read async
    
    private func readFromStore(type: Object.Type,
                               completion: ObjectsResolvedHandler?) {
        
        workingQueue.async { [weak self] in
            
            autoreleasepool {
                
                guard let realm =  self?.privateContextRealm else {
                    return
                }
                
                let realmObjects = { realm.objects(type) }()
                if let sorted = self?.sort(results: realmObjects) {
                    
                    self?.resultsDidUpdated(with: type, entities: sorted)
                    
                    completion?(self, ThreadSafeReference(to: sorted))
                    
                } else {
                    
                    self?.resultsDidUpdated(with: type, entities: realmObjects)
                    
                    completion?(self, ThreadSafeReference(to: realmObjects))
                }
            }
        }
    }
    
    // MARK: - Write async
    
    private func writeToStore<T : ThreadConfined>(object: T,
                                                  failure: ErrorHandler?,
                                                  block: @escaping ((Realm, T?) -> Void)) {
        
        if object.realm == nil {
            
            writeAsync(object: object,
                       failure: failure,
                       block: block)
        } else {
            
            writeAsync(withTradeSafeWrapped: object,
                       failure: failure,
                       block: block)
        }
    }
    
    private func writeAsync<T : ThreadConfined>(withTradeSafeWrapped object: T,
                                                failure: ErrorHandler?,
                                                block: @escaping ((Realm, T?) -> Void)) {
        
        let wrappedObj = ThreadSafeReference(to: object)
        
        workingQueue.async { [weak self] in
            
            autoreleasepool {
                do {
                    
                    guard let realm = self?.privateContextRealm else {
                        return
                    }
                    
                    let object = realm.resolve(wrappedObj)
                    
                    try  realm.write {
                        
                        block(realm, object)
                    }
                } catch {
                    failure?(error)
                }
            }
        }
    }
    
    private func writeAsync<T : ThreadConfined>(object: T,
                                                failure: ErrorHandler?,
                                                block: @escaping ((Realm, T?) -> Void)) {
        
        workingQueue.async { [weak self] in
            
            autoreleasepool {
                do {
                    
                    guard let realm = self?.privateContextRealm else {
                        return
                    }
                    
                    try  realm.write {
                        
                        block(realm, object)
                    }
                } catch {
                    failure?(error)
                }
            }
        }
    }
}

// MARK: - IRealmProvider

extension RealmProvider: IRealmProvider {
    
    // MARK: - Resolving
    
    func resolve<T>(_ wrapped: ThreadSafeReference<T>) -> T? where T : ThreadConfined {
        
        guard let resolved = privateContextRealm?.resolve(wrapped) else {
            
            return nil
        }
        
        return resolved
    }
    
    // MARK: - Writing
    
    func write<Element: Object>(element: Element,
                                failure: ErrorHandler?) {
        
        let writeBlock: (Realm, Element?) -> Void = { realm, element in
            
            if let element = element {
                realm.add(element)
            }
        }
        
        writeToStore(object: element,
                     failure: failure,
                     block: writeBlock)
    }
    
    func overwrite<Element: Object>(element: Element,
                                    failure: ErrorHandler?) {
        
        writeAsync(object: element,
                   failure: { error in
                    print(error)
        },
                   block: { realm, element in
                    
                    if let element = element {
                        realm.add(element, update: .modified)
                    }
        })
    }
    
    // MARK: - Reading
    
    func read(type: Object.Type,
              completion: ObjectsResolvedHandler?,
              failure: ErrorHandler?) {
        
        let typeString = NSStringFromClass(type.self)
        
        if let wrapped = resultsDictionary[typeString],
            !wrapped.isInvalidated {
            
            if  let resolved = resolve(wrapped) {
                
                resultsDidUpdated(with: type, entities: resolved)
                
                weak var welf = self
                
                completion?(welf ,ThreadSafeReference(to: sort(results: resolved)))
            }
            
        } else {
            
            readFromStore(type: type, completion: completion)
        }
    }
    
    // MARK: - Deletion
    
    func delete<Element: Object>(element: Element,
                                 failure: ErrorHandler?) {
        
        let deleteBlock: (Realm, Element?) -> Void = { realm, element in
            
            if let element = element {
                realm.delete(element)
            }
        }
        
        writeToStore(object: element,
                     failure: failure,
                     block: deleteBlock)
    }
    
    func delete<Element: Object>(elements: Results<Element>,
                                 failure: ErrorHandler?) {
        
        let deleteBlock: (Realm, Results<Element>?) -> Void = { realm, elements in
            
            if let elements = elements {
                realm.delete(elements)
            }
        }
        
        writeToStore(object: elements,
                     failure: failure,
                     block: deleteBlock)
    }
    
    func deleteAll(failure: ErrorHandler?) {
        
        workingQueue.async { [weak self] in
            
            autoreleasepool {
                
                do {
                    
                    guard let realm = self?.privateContextRealm else {
                        return
                    }
                    
                    try realm.write {
                        realm.deleteAll()
                    }
                } catch let error {
                    
                    failure?(error)
                }
            }
        }
    }
    
    // MARK: - Application life cycle
    
    func didEnterBackground(failure: ErrorHandler?) { }
}
