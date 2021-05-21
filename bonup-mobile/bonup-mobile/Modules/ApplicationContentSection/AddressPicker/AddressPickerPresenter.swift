//
//  AddressPickerPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IAddressPickerPresenter: AnyObject {

    func handleDoneButtonTap()
    
    var suggestions: [String] { get }
    var currentAddress: String? { get set }
}

final class AddressPickerPresenter {

    // MARK: - Private variables

    private weak var view: IAddressPickerView?
    private let interactor: IAddressPickerInteractor
    private let router: IAddressPickerRouter

    // MARK: - Init

    init(view: IAddressPickerView?,
         interactor: IAddressPickerInteractor,
         router: IAddressPickerRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IAddressPickerPresenter

extension AddressPickerPresenter: IAddressPickerPresenter {

    func handleDoneButtonTap() {

        self.interactor.getLocation(completion: { [weak self] longitude, latitude in
            
            guard let self = self else { return }
            
            self.router.stop(address: self.interactor.currentAddress, longitude: longitude, latitude: latitude)
            
        }, failure: { [weak self] message in
            
            DispatchQueue.main.async {
                
                self?.router.show(.showResultAlert(message))
            }
        })
    }
    
    var suggestions: [String] {
        
        return self.interactor.suggestions
    }
    
    var currentAddress: String? {
        
        get {
            
            return self.interactor.currentAddress
        }
        
        set {
            
            self.interactor.updateCurrentAddress(newValue ?? "", completion: { [weak self] isSuccess in
                
                DispatchQueue.main.async {
                    
                    self?.view?.reloadData()
                }
            })
        }
    }
}
