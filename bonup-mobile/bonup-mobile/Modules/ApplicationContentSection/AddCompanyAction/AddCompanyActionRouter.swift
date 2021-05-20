//
//  AddCompanyActionRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 25.04.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import FMPhotoPicker

protocol IAddCompanyActionRouter {

    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: AddCompanyActionRouter.RouterScenario)
}

final class AddCompanyActionRouter {

    enum RouterScenario {

        case addImage(FMPhotoPickerViewControllerDelegate)
        case showResultAlert(String, Bool)
    }

    private var view: AddCompanyActionView?
    private var parentNavigationController: UINavigationController

    init(view: AddCompanyActionView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - IAddCompanyRouter implementation

extension AddCompanyActionRouter: IAddCompanyActionRouter {

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
        
        guard let view = self.view else { return }

        switch scenario {

        case .addImage(let delegate):
            let picker = FMPhotoPickerViewController(config: FMPhotoPickerViewController.defaultConfig)
            picker.delegate = delegate
            view.present(picker, animated: true)
            
        case .showResultAlert(let message, let success):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_help_title".localized,
                description: message,
                from: view,
                completion: { [weak self] in
                    
                    if success {
                        
                        self?.stop(nil)
                    }
                }
            )
        }
    }
}
