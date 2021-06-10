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
    var selectedPhoto: UIImage { get set }
    var moduleMode: AddCompanyDependency.Mode { get }

    func handleValueUpdate(_ value: String?, at indexPath: IndexPath)
    func handleAddImageTap()
    func handleDoneTap()
    func handleActionsAggregatorTap()
    func handleSectionsUpdate(categories: [InterestCategories])
    func handleViewDidLoad()
    func handleAddressTap()
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
    
    func handleViewDidLoad() {
        
        if self.moduleMode != .create {
            
            guard let company = self.interactor.initCompany,
                  let url = PhotosService.photoURL(for: company.photoId) else { return }
            
            self.view?.loadImage(url,
                                 completion: { [weak self] image in
                
                self?.selectedPhoto = image
            })
        }
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
    
    var moduleMode: AddCompanyDependency.Mode {
        
        return self.interactor.moduleMode
    }
    
    var selectedPhoto: UIImage {
        
        get { self.interactor.selectedPhoto }
        set { self.interactor.selectedPhoto = newValue }
    }
    
    func handleActionsAggregatorTap() {
        
        guard let company = self.interactor.initCompany else { return }
        
        self.router.show(.actionsAggregator(company.title))
    }
    
    func handleAddressTap() {
        
        self.view?.updateBlurState(active: true)
        
        self.router.show(.showAddressPicker({ [weak self] address, longitude, latitude in
            
            guard let self = self else { return }
            
            guard let indexPath = self.indexPath(of: .address) else { return }
            
            self.interactor.updateValue(address, at: indexPath)
            self.interactor.companyLongitude = longitude
            self.interactor.companyLatitude = latitude
            
            self.view?.reloadRow(at: indexPath)
            
            self.view?.updateBlurState(active: false)
        }))
    }
    
    // MARK: - Private
    
    private func indexPath(of fieldType: AddCompanyInputRowModelType) -> IndexPath? {
        
        for (sectionIndex, section) in self.interactor.inputSections.enumerated() {
            
            for (rowIndex, row) in section.rows.enumerated() {
                
                if row.rowType == fieldType {
                    
                    return IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
        }
        
        return nil
    }
}

// MARK: - FMPhotoPickerViewControllerDelegate

extension AddCompanyPresenter: FMPhotoPickerViewControllerDelegate {

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController,
                                 didFinishPickingPhotoWith photos: [UIImage]) {

        self.view?.setupImage(photos.first ?? AssetsHelper.shared.image(.addImageIcon)!)
        self.router.show(.dissmisPhotoPicker)
    }
}
