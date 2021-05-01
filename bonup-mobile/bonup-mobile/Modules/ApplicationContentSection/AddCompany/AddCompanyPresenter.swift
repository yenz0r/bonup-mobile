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

    func handleValueUpdate(_ value: String?, at indexPath: IndexPath)
    func handleAddImageTap()
    func handleDoneTap()
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
    
    func handleValueUpdate(_ value: String?, at indexPath: IndexPath) {
        
    }
    
    func handleAddImageTap() {

        self.router.show(.addImage(self))
    }

    var inputSections: [AddCompanyInputSectionModel] {

        return self.interactor.inputSections
    }
    
    func handleDoneTap() {
        
        self.router.show(.organizationsList)
    }
}

// MARK: - FMPhotoPickerViewControllerDelegate

extension AddCompanyPresenter: FMPhotoPickerViewControllerDelegate {

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController,
                                 didFinishPickingPhotoWith photos: [UIImage]) {

        self.view?.setupImage(photos.first ?? AssetsHelper.shared.image(.addImageIcon)!)
    }
}
