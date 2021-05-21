//
//  AddressPickerRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import UBottomSheet

protocol IAddressPickerRouter {

    func start(stopCompletion: ((String, Double, Double) -> Void)?)
    func stop(address: String, longitude: Double, latitude: Double)
    func show(_ scanario: AddressPickerRouter.RouterScenario)
}

final class AddressPickerRouter {

    enum RouterScenario {
        
        case showLoader
        case hideLoader
        case showResultAlert(String)
    }
    
    // MARK: - Private variables
    
    private var view: AddressPickerView?
    private var parentController: UIViewController
    private var onTerminate: ((String, Double, Double) -> Void)?

    // MARK: - Init
    
    init(view: AddressPickerView?, parentController: UIViewController) {

        self.view = view
        self.parentController = parentController
    }
}

// MARK: - IAddressPickerRouter implementation

extension AddressPickerRouter: IAddressPickerRouter, UBottomSheetCoordinatorDelegate {

    func start(stopCompletion: ((String, Double, Double) -> Void)?) {

        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        let sheetCoordinator = UBottomSheetCoordinator(parent: self.parentController,
                                                       delegate: self)

        view.sheetCoordinatorDataSource = sheetCoordinator.defaultDataSource(maxHeight: 400)
        view.sheetCoordinator = sheetCoordinator
        view.sheetCoordinator?.dataSource = view.sheetCoordinatorDataSource

        sheetCoordinator.addSheet(view, to: self.parentController, didContainerCreate: { container in

            container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            container.layer.cornerRadius = 10
            container.layer.theme_borderColor = Colors.defaultTextCGColorWithAlpha
            container.layer.borderWidth = 1
            container.layer.masksToBounds = true
        })
        sheetCoordinator.setCornerRadius(10)

        self.onTerminate = stopCompletion
    }

    func stop(address: String, longitude: Double, latitude: Double) {

        guard let view = self.view else { return }

        view.sheetCoordinator?.removeSheet()

        self.onTerminate?(address, longitude, latitude)

        self.view = nil
    }
    
    func show(_ scanario: RouterScenario) {
        
        guard let view = self.view else { return }
        
        switch scanario {
         
        case .showLoader:
            AlertsFactory.shared.loadingAlert(.show(message: "ui_wait_a_bit_please".localized))
            
        case .hideLoader:
            AlertsFactory.shared.loadingAlert(.hide)
            
        case .showResultAlert(let message):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_help_title".localized,
                description: message,
                from: view,
                completion: nil
            )
        }
    }
}
