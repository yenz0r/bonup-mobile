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

    func handleAddImageTap()
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

    func handleAddImageTap() {

        self.router.show(.addImage(self))
    }

    var inputSections: [AddCompanyInputSectionModel] {

        return self.interactor.inputSections
    }
}

// MARK: - FMPhotoPickerViewControllerDelegate

extension AddCompanyPresenter: FMPhotoPickerViewControllerDelegate {

    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {

    }
}
