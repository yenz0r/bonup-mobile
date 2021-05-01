//
//  OrganizationControl.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import SwiftQRScanner

protocol IOrganizationControlRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: OrganizationControlRouter.RouterScenario)
}

final class OrganizationControlRouter {
    enum RouterScenario {

        case showResultAlert(String)
        case showAddAction(CompanyActionType, String)
        case verifyAction(QRScannerCodeDelegate)
    }

    private var view: OrganizationControlView?
    private var parentController: UIViewController

    init(view: OrganizationControlView?, parentController: UIViewController) {
        self.view = view
        self.parentController = parentController
    }
}

// MARK: - ICategoriesRouter implementation

extension OrganizationControlRouter: IOrganizationControlRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentController.navigationController?.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentController.navigationController?.popViewController(animated: true)
        completion?()
        self.view = nil
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
            
        case .showAddAction(let actionType, let organizationId):
            
            let dependency = AddCompanyActionDependency(
                parentNavigationController: self.parentController.navigationController!,
                actionType: actionType,
                organizationId: organizationId
            )
            let builder = AddCompanyActionBuilder()
            let router = builder.build(dependency)
            router.start(nil)
            
        case .verifyAction(let qrCodeDelegate):
            
            let scanner = QRCodeScannerController()
            scanner.delegate = qrCodeDelegate
            
            self.view?.present(scanner, animated: true, completion: nil)
        }
    }
}
