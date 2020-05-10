//
//  BenefitsPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IBenefitsPresenter: AnyObject {

    func handleShowDescription(for index: Int)
}

final class BenefitsPresenter {

    private weak var view: IBenefitsView?
    private let interactor: IBenefitsInteractor
    private let router: IBenefitsRouter

    init(view: IBenefitsView?, interactor: IBenefitsInteractor, router: IBenefitsRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IBenefitsPresenter implementation

extension BenefitsPresenter: IBenefitsPresenter {

    func handleShowDescription(for index: Int) {

        self.router.show(.benefitDescription)
    }
}
