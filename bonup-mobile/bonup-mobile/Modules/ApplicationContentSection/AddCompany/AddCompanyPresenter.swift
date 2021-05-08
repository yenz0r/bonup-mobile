//
//  AddCompanyPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import FMPhotoPicker

protocol IAddCompanyPresenter: AnyObject {

    var inputSections: [AddCompanyInputSectionModel] { get }
    var selectedCategory: InterestCategories { get }
    var moduleMode: AddCompanyInteractor.ModuleMode { get }

    func handleValueUpdate(_ value: String?, at indexPath: IndexPath)
    func handleAddImageTap()
    func handleDoneTap()
    func handleSectionsUpdate(categories: [InterestCategories])
}

final class AddCompanyPresenter {

    // MARK: - Private variables

    private weak var view: IAddCompanyView?
    private let interactor: IAddCompanyInteractor
    private let router: IAddCompanyRouter

    // MARK: - Init

    init(view: IAddCompanyView?, interactor: IAddCompanyInteractor, router: IAddCompanyRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IAddCompanyPresenter

extension AddCompanyPresenter: IAddCompanyPresenter {
    
    var selectedCategory: InterestCategories {
        
        return self.interactor.selectedCategory
    }
    
    func handleValueUpdate(_ value: String?, at indexPath: IndexPath) {
        
        self.interactor.updateValue(value, at: indexPath)
    }
    
    func handleAddImageTap() {

        self.router.show(.addImage(self))
    }

    var inputSections: [AddCompanyInputSectionModel] {

        return self.interactor.inputSections
    }
    
    func handleDoneTap() {
        
        self.interactor.addCompany(
            success: { [weak self] in
                
                DispatchQueue.main.async {
                 
                    self?.router.stop(nil)
                }
            },
            failure: { [weak self] message in
                
                DispatchQueue.main.async {
                
                    self?.router.show(.showResultAlert(message))
                }
            }
        )
    }
    
    func handleSectionsUpdate(categories: [InterestCategories]) {
        
        if let category = categories.first {
        
            self.interactor.selectedCategory = category
        }
    }
    
    var moduleMode: AddCompanyInteractor.ModuleMode {
        
        return self.interactor.moduleMode
    }
}

// MARK: - FMPhotoPickerViewControllerDelegate

extension AddCompanyPresenter: FMPhotoPickerViewControllerDelegate {

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController,
                                 didFinishPickingPhotoWith photos: [UIImage]) {

        self.view?.setupImage(photos.first ?? AssetsHelper.shared.image(.addImageIcon)!)
    }
}
