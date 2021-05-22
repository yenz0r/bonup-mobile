//
//  CompanyPacketRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyPacketRouter {

    func start(onStop: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: CompanyPacketRouter.RouterScenario,
              completion: ((CompanyPacketType) -> Void)?)
}

final class CompanyPacketRouter {

    enum RouterScenario {

        case customPacket
        case addCompany(packet: CompanyPacketType, onStop: (() -> Void)?)
        case showAlert(text: String)
    }

    // MARK: - Private variables
    
    private var view: CompanyPacketView?
    private var parentNavigationController: UINavigationController
    private var onTerminate: (() -> Void)?
    
    // MARK: - Init
    
    init(view: CompanyPacketView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICompanyPacketRouter implementation

extension CompanyPacketRouter: ICompanyPacketRouter {

    func start(onStop: (() -> Void)?) {
        
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentNavigationController.pushViewController(view, animated: true)
        
        self.onTerminate?()
    }

    func stop(_ completion: (() -> Void)?) {
        
        self.parentNavigationController.popViewController(animated: true)
        self.view = nil

        completion?()
        self.onTerminate?()
    }

    func show(_ scenario: RouterScenario, completion: ((CompanyPacketType) -> Void)?) {
        
        guard let view = self.view else { return }

        switch scenario {

        case .customPacket:

            let dependency = CompanyCustomPacketDependency(parentController: view)
            let builder = CompanyCustomPacketBuilder()
            let router = builder.build(dependency)

            router.start { customType in
                
                completion?(customType)
            }
            
        case .addCompany(let companyPacket, let onStop):
            
            let dependency = AddCompanyDependency(
                parentNavigationController: self.parentNavigationController,
                initCompany: nil,
                mode: .create,
                companyPacket: companyPacket
            )
            let builder = AddCompanyBuilder()
            let router = builder.build(dependency)
            
            router.start(onStop: onStop)
            
        case .showAlert(let text):
            
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_help_title".localized,
                description: text,
                from: view,
                completion: nil
            )
        }
    }
}
