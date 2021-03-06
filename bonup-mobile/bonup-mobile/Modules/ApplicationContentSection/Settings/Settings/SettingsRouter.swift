//
//  SettingsRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import StoreKit
import FMPhotoPicker

protocol ISettingsRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: SettingsRouter.SettingsRouterScenario)
}

final class SettingsRouter {
    enum SettingsRouterScenario {
        case changePassword
        case logout
        case categories
        case rateUs
        case help
        case inProgress(String)
        case params(SettingsParamsDependency.SettingsParamsType)
        case avatarSelection(FMPhotoPickerViewControllerDelegate)
        case showErrorAlert(String)
        
        case showLoadingAlert
        case hideLoadingAlert
        
        case dissmisPhotoPicker
    }

    private var view: SettingsView?
    private var parentNavigationController: UINavigationController

    init(view: SettingsView?, parentNavigationController: UINavigationController) {
        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICategoriesRouter implementation

extension SettingsRouter: ISettingsRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentNavigationController.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentNavigationController.popViewController(animated: true)
        completion?()
        self.view = nil
    }

    func show(_ scenario: SettingsRouterScenario) {
        guard let view = self.view else { return }

        switch scenario {
        case .changePassword:
            let dependency = ChangePasswordDependency(parentController: view)
            let builder = ChangePasswordBuilder()
            let router = builder.build(dependency)
            router.start(nil)
        case .logout:
            AppRouter.shared.present(.login(name: nil, email: nil))
        case .categories:
            let dependency = CategoriesDependency(parentViewController: view,
                                                  target: .settings)
            let builder = CategoriesBuilder()
            let router = builder.build(dependency)
            router.start(nil)
        case .rateUs:
            SKStoreReviewController.requestReview()
        case .help:
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_help_title".localized,
                description: "ui_help_description".localized,
                from: view,
                completion: nil
            )
        case .inProgress(let message):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: message,
                description: "ui_in_progress".localized,
                from: view,
                completion: nil
            )
        case .params(let paramType):
            let dependecy = SettingsParamsDependency(
                settingsParamsType: paramType,
                parentNavigationController: self.parentNavigationController
            )
            let builder = SettingsParamsBuilder()
            let router = builder.build(dependecy)
            router.start(nil)
        case .avatarSelection(let delegate):

            let picker = FMPhotoPickerViewController(config: FMPhotoPickerViewController.defaultConfig)
            picker.delegate = delegate
            self.view?.present(picker, animated: true)

        case .showErrorAlert(let message):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_error_title".localized,
                description: message,
                from: view,
                completion: {
                    print("error")
                }
            )
            
        case .showLoadingAlert:
            
            AlertsFactory.shared.loadingAlert(.show(message: "ui_wait_a_bit_please".localized))
            
        case .hideLoadingAlert:
            
            AlertsFactory.shared.loadingAlert(.hide)
            
        case .dissmisPhotoPicker:
        
            self.view?.dismiss(animated: true, completion: nil)
        }
    }
}
