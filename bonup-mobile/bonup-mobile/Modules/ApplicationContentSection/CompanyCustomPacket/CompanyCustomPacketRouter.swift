//
//  CompanyCustomPacketRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import UBottomSheet

protocol ICompanyCustomPacketRouter {

    func start(stopCompletion: ((CompanyPacketType) -> Void)?)
    func stop(tasksCount: Int, benefitsCount: Int, price: Float)
    func show(_ scenario: CompanyCustomPacketRouter.RouterScenario)
}

final class CompanyCustomPacketRouter {

    enum RouterScenario { }

    private var view: CompanyCustomPacketView?
    private var parentController: UIViewController

    private var onTerminate: ((CompanyPacketType) -> Void)?

    init(view: CompanyCustomPacketView?, parentController: UIViewController) {

        self.view = view
        self.parentController = parentController
    }
}

// MARK: - ICompanyCustomPacketRouter implementation

extension CompanyCustomPacketRouter: ICompanyCustomPacketRouter, UBottomSheetCoordinatorDelegate {

    func start(stopCompletion: ((CompanyPacketType) -> Void)?) {

        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        let sheetCoordinator = UBottomSheetCoordinator(parent: self.parentController,
                                                       delegate: self)

        view.sheetCoordinatorDataSource = sheetCoordinator.defaultDataSource(maxHeight: 300)
        view.sheetCoordinator = sheetCoordinator
        view.sheetCoordinator?.dataSource = view.sheetCoordinatorDataSource

        sheetCoordinator.addSheet(view, to: self.parentController, didContainerCreate: { container in

            container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            container.layer.cornerRadius = 10
            container.layer.masksToBounds = true
        })
        sheetCoordinator.setCornerRadius(10)

        self.onTerminate = stopCompletion
    }

    func stop(tasksCount: Int, benefitsCount: Int, price: Float) {

        guard let view = self.view else { return }

        view.sheetCoordinator?.removeSheet()

        self.onTerminate?(.custom(tasksCount: tasksCount, benefitsCount: benefitsCount, price: price))

        self.view = nil
    }

    func show(_ scenario: RouterScenario) { }
}

