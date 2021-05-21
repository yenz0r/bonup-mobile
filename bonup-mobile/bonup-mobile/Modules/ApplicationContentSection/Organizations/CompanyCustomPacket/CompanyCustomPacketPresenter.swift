//
//  CompanyCustomPacketPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyCustomPacketPresenter: AnyObject {

    func setupTasksCount(_ count: Int)
    func setupBenefitsCount(_ count: Int)

    func handleDoneButtonTap()
}

final class CompanyCustomPacketPresenter {

    // MARK: - Private variables

    private weak var view: ICompanyCustomPacketView?
    private let interactor: ICompanyCustomPacketInteractor
    private let router: ICompanyCustomPacketRouter

    // MARK: - Init

    init(view: ICompanyCustomPacketView?,
         interactor: ICompanyCustomPacketInteractor,
         router: ICompanyCustomPacketRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICompanyCustomPacketPresenter

extension CompanyCustomPacketPresenter: ICompanyCustomPacketPresenter {

    func setupTasksCount(_ count: Int) {

        self.interactor.tasksCount = count

        self.view?.updatePrice(self.interactor.price)
    }

    func setupBenefitsCount(_ count: Int) {

        self.interactor.benefitsCount = count

        self.view?.updatePrice(self.interactor.price)
    }

    func handleDoneButtonTap() {

        self.router.stop(tasksCount: self.interactor.tasksCount,
                         benefitsCount: self.interactor.benefitsCount,
                         price: self.interactor.price)
    }
}
