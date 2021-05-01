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
    
    func fieldTitle(at index: Int) -> String
    func fieldValue(at index: Int) -> String
    func fieldType(at index: Int) -> CompanyActionFieldType

    func handleValueUpdate(_ value: Any, at indexPath: IndexPath)
    func handleCategoriesUpdate(_ categoriesIds: [Int])
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
    
    func handleValueUpdate(_ value: Any, at indexPath: IndexPath) {
        
        self.interactor.updateValue(value, at: indexPath.row)
    }
    
    func handleAddImageTap() {

        self.router.show(.addImage(self))
    }

    var fieldsCount: Int {
        
        return self.interactor.viewModels.count
    }
    
    func handleDoneTap() {
        
        self.interactor.handleAddAction { [weak self] message in
            
            self?.router.show(.showResultAlert(message))
            self?.router.stop(nil)
        }
        failure: { [weak self] message in
            
            self?.router.show(.showResultAlert(message))
        }
    }
    
    func handleCategoriesUpdate(_ categoriesIds: [Int]) {
        
        self.interactor.categoriesIds = categoriesIds
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

        self.view?.setupImage(photos.first ?? AssetsHelper.shared.image(.addImageIcon)!)
    }
}
