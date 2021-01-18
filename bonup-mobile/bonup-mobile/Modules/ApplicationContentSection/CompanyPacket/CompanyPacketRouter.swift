//
//  CompanyPacketRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyPacketRouter {

    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: CompanyPacketRouter.RouterScenario)
}

final class CompanyPacketRouter {

    enum RouterScenario {


    }

    private var view: CompanyPacketView?
    private var parentNavigationController: UINavigationController

    init(view: CompanyPacketView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICompanyPacketRouter implementation

extension CompanyPacketRouter: ICompanyPacketRouter {

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

        }
    }
}
