//
//  AddCompanyRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import FMPhotoPicker

protocol IAddCompanyRouter {

    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: AddCompanyRouter.RouterScenario)
}

final class AddCompanyRouter {

    enum RouterScenario {

        case addImage(FMPhotoPickerViewControllerDelegate)
    }

    private var view: AddCompanyView?
    private var parentNavigationController: UINavigationController

    init(view: AddCompanyView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - IAddCompanyRouter implementation

extension AddCompanyRouter: IAddCompanyRouter {

    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentNavigationController.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentNavigationController.popViewController(animated: true)
        self.view = nil

        completion?()
    }

    func show(_ scenario: RouterScenario) {
//        guard let view = self.view else { return }

        switch scenario {

        case .addImage(let delegate):

            let picker = FMPhotoPickerViewController(config: FMPhotoPickerViewController.defaultConfig)
            picker.delegate = delegate
            self.view?.present(picker, animated: true)
        }
    }
}
