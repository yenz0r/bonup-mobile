//
//  CompanyStatisticsRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 2.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyStatisticsRouter {

    func start(startCompletion: (() -> Void)?)
    func stop(withPop: Bool, stopCompetion: (() -> Void)?)
    func show(_ scenario: CompanyStatisticsRouter.RouterScenario)
}

final class CompanyStatisticsRouter {

    enum RouterScenario { }

    private var view: CompanyStatisticsView?
    private var parentNavigationController: UINavigationController

    init(view: CompanyStatisticsView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICompanyCustomPacketRouter implementation

extension CompanyStatisticsRouter: ICompanyStatisticsRouter {

    func start(startCompletion: (() -> Void)?) {

        guard let view = self.view else { return }

        self.parentNavigationController.pushViewController(view, animated: true)
    }

    func stop(withPop: Bool, stopCompetion: (() -> Void)?) {
        
        if withPop {
        
            self.parentNavigationController.popViewController(animated: true)
        }
        
        self.view = nil
    }

    func show(_ scenario: RouterScenario) { }
}

