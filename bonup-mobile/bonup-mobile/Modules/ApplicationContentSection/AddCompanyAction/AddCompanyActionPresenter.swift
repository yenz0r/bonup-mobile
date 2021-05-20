//
//  AddCompanyActionPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 25.04.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import FMPhotoPicker

protocol IAddCompanyActionPresenter: AnyObject {

    var fieldsCount: Int { get }
    var screenTitle: String { get }
    var selectedCategory: InterestCategories { get }
    var selectedPhoto: UIImage { get set }
    
    var currentMode: AddCompanyActionDependency.Mode { get }
    
    func fieldTitle(at index: Int) -> String
    func fieldValue(at index: Int) -> String
    func fieldType(at index: Int) -> CompanyActionFieldType

    func handleValueUpdate(_ value: Any, at indexPath: IndexPath)
    func handleCategoriesUpdate(_ categories: [InterestCategories])
    func handleAddImageTap()
    func handleDoneTap()
}

final class AddCompanyActionPresenter {

    // MARK: - Private variables

    private weak var view: IAddCompanyActionView?
    private let interactor: IAddCompanyActionInteractor
    private let router: IAddCompanyActionRouter

    // MARK: - Init

    init(view: IAddCompanyActionView?,
         interactor: IAddCompanyActionInteractor,
         router: IAddCompanyActionRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IAddCompanyPresenter

extension AddCompanyActionPresenter: IAddCompanyActionPresenter {
    
    var selectedPhoto: UIImage {
        
        get { self.interactor.selectedPhoto }
        set { self.interactor.selectedPhoto = newValue }
    }
    
    
    func handleValueUpdate(_ value: Any, at indexPath: IndexPath) {
        
        self.interactor.updateValue(value, at: indexPath.row)
    }
    
    func handleAddImageTap() {

        self.router.show(.addImage(self))
    }

    var fieldsCount: Int {
        
        return self.interactor.viewModels.count
    }
    
    var currentMode: AddCompanyActionDependency.Mode {
        
        return self.interactor.mode
    }
    
    func handleDoneTap() {
        
        self.interactor.addAction { [weak self] message in
            
            DispatchQueue.main.async {
             
                self?.router.show(.showResultAlert(message, true))
            }
        }
        failure: { [weak self] message in
            
            DispatchQueue.main.async {
             
                self?.router.show(.showResultAlert(message, false))
            }
        }
    }
    
    func handleCategoriesUpdate(_ categories: [InterestCategories]) {
        
        if let category = categories.first {
        
            self.interactor.selectedCategory = category
        }
    }
    
    var selectedCategory: InterestCategories {
        
        self.interactor.selectedCategory
    }
    
    func fieldType(at index: Int) -> CompanyActionFieldType {
        
        return self.interactor.viewModels[index].fieldType
    }
    
    func fieldTitle(at index: Int) -> String {
    
        return self.interactor.viewModels[index].fieldType.title
    }
    
    func fieldValue(at index: Int) -> String {
        
        let viewModel = self.interactor.viewModels[index]
        
        switch viewModel.fieldType {
        case .title:
            fallthrough
        case .description:
            return (viewModel.value as? String) ?? ""
            
        case .startDate:
            fallthrough
        case .endDate:
            return Date.dateFormatter.string(from: viewModel.value as? Date ?? Date())
            
        case .bonuses:
            fallthrough
        case .allowedCount:
            return String(viewModel.value as? String ?? "")
        }
    }
    
    var screenTitle: String {
        
        return self.interactor.actionType.title
    }
}

// MARK: - FMPhotoPickerViewControllerDelegate

extension AddCompanyActionPresenter: FMPhotoPickerViewControllerDelegate {

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController,
                                 didFinishPickingPhotoWith photos: [UIImage]) {
        
        let photo = photos.first ?? AssetsHelper.shared.image(.addImageIcon)!
        
        self.view?.setupImage(photo)
        self.selectedPhoto = photo
    }
}
