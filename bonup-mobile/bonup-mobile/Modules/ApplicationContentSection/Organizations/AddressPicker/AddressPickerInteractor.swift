//
//  AddressPickerInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IAddressPickerInteractor: AnyObject {

    var currentAddress: String { get }
    var suggestions: [String] { get }
    
    func updateCurrentAddress(_ address: String?, completion: @escaping (Bool) -> Void)
    func getLocation(completion: @escaping (Double, Double) -> Void, failure: @escaping (String) -> Void)
}

final class AddressPickerInteractor {

    // MARK: - Managers variables
    
    private let searchManager: MapSearchManager
    private let suggestsManager: MapSuggestsManager
    
    // MARK: - State variables
    
    var currentAddress: String
    var suggestions: [String] = []
    
    // MARK: - Init
    
    init(initAddress: String?,
         searchManager: MapSearchManager,
         suggestsManager: MapSuggestsManager) {
        
        self.currentAddress = initAddress ?? ""
        self.searchManager = searchManager
        self.suggestsManager = suggestsManager
    }
}

// MARK: - IAddressPickerInteractor implementation

extension AddressPickerInteractor: IAddressPickerInteractor {
    
    func updateCurrentAddress(_ address: String?, completion: @escaping (Bool) -> Void) {
        
        guard let address = address else { return }
        
        self.currentAddress = address
        
        self.suggestsManager.suggests(
            for: address,
            completion: { items, err in
                
                self.suggestions = items?.compactMap { $0.displayText } ?? []
                completion(true)
            })
    }
    
    func getLocation(completion: @escaping (Double, Double) -> Void,
                     failure: @escaping (String) -> Void) {
        
        self.searchManager.search(
            for: self.currentAddress,
            completion: { points, error in
                
                if let point = points.first {
                 
                    completion(point.longitude, point.latitude)
                }
                else {
                    
                    failure(error?.localizedDescription ?? "ui_error_title".localized)
                }
            })
    }
}
