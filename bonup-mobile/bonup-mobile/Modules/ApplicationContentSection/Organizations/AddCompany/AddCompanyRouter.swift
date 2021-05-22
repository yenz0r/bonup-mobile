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

    func start(onStop: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: AddCompanyRouter.RouterScenario)
}

final class AddCompanyRouter {

    enum RouterScenario {

        case addImage(FMPhotoPickerViewControllerDelegate)
        case organizationsList
        case showResultAlert(String)
        case actionsAggregator(String)
        case showLoadingAlert
        case hideLoadingAlert
        case dissmisPhotoPicker
        case showAddressPicker(((String, Double, Double) -> Void)?)
    }
    
    // MARK: - Private variables

    private var view: AddCompanyView?
    private var parentNavigationController: UINavigationController
    private var onTeminate: (() -> Void)?

    // MARK: - Init
    
    init(view: AddCompanyView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - IAddCompanyRouter implementation

extension AddCompanyRouter: IAddCompanyRouter {

    func start(onStop: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentNavigationController.pushViewController(view, animated: true)
        
        self.onTeminate = onStop
    }

    func stop(_ completion: (() -> Void)?) {
        
        self.parentNavigationController.popToRootViewController(animated: true)
        self.view = nil

        completion?()
        self.onTeminate?()
    }

    func show(_ scenario: RouterScenario) {
        
        guard let view = self.view else { return }

        switch scenario {
        
        case .showResultAlert(let message):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_help_title".localized,
                description: message,
                from: view,
                completion: nil
            )

        case .addImage(let delegate):

            let picker = FMPhotoPickerViewController(config: FMPhotoPickerViewController.defaultConfig)
            picker.delegate = delegate
            view.present(picker, animated: true)
            
        case .organizationsList:
            
            self.parentNavigationController.popToRootViewController(animated: true)
            
        case .showLoadingAlert:
            
            AlertsFactory.shared.loadingAlert(.show(message: "ui_wait_a_bit_please".localized))
            
        case .hideLoadingAlert:
            
            AlertsFactory.shared.loadingAlert(.hide)
            
        case .actionsAggregator(let companyName):
            
            let dependency = CompanyActionsAggregatorDependency(
                parentNavigationController: self.parentNavigationController,
                companyName: companyName
            )
            let builder = CompanyActionsAggregatorBuilder()
            let router = builder.build(dependency)
            
            router.start(nil)
            
        case .dissmisPhotoPicker:
        
            self.view?.dismiss(animated: true, completion: nil)
            
        case .showAddressPicker(let completion):
            
            let dependency = AddressPickerDependency(parentController: view, initAdderss: nil)
            let builder = AddressPickerBuilder()
            let router = builder.build(dependency)
            
            router.start { address, longitude, latitude in
                
                completion?(address, longitude, latitude)
            }
        }
    }
}
