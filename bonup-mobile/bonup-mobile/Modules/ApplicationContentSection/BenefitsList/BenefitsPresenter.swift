//
//  BenefitsPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IBenefitsPresenter: AnyObject {

    func handleBuyBenefit(for index: Int)
    func handleShowDescription(for index: Int)
    func handleShowHelpAction()
    func viewWillAppear()

    var savedBenfits: [ActualBenefitEntity] { get }
    var boughtBenfits: [ActualBenefitEntity] { get }
    var finishedBenefits: [FinishedBenefitEntity] { get }

    var pages: [String] { get }
}

final class BenefitsPresenter {

    private weak var view: IBenefitsView?
    private let interactor: IBenefitsInteractor
    private let router: IBenefitsRouter

    private var responseEntity: BenefitsResponseEntity?

    private var saved: [ActualBenefitEntity]?
    private var bought: [ActualBenefitEntity]?
    private var finished: [FinishedBenefitEntity]?

    init(view: IBenefitsView?, interactor: IBenefitsInteractor, router: IBenefitsRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IBenefitsPresenter implementation

extension BenefitsPresenter: IBenefitsPresenter {

    var pages: [String] {

        return [
            "ui_new_title".localized,
            "ui_selected_title".localized,
            "ui_used_title".localized
        ]
    }

    var savedBenfits: [ActualBenefitEntity] {
        return self.saved ?? []
    }

    var boughtBenfits: [ActualBenefitEntity] {
        return self.bought ?? []
    }

    var finishedBenefits: [FinishedBenefitEntity] {
        return self.finished ?? []
    }

    func handleShowHelpAction() {

        self.router.show(.showHelpAlert)
    }

    func handleShowDescription(for index: Int) {

        guard let boughtBenefits = self.bought else { return }

        self.router.show(.benefitDescription(boughtBenefits[index]))
    }

    func handleBuyBenefit(for index: Int) {

        guard let saved = self.saved else { return }

        let id = saved[index].id

        self.interactor.buyBenefits(id: id,

                                    success: { [weak self] entity in

                                        self?.responseEntity = entity
                                        self?.bought = entity.bought
                                        self?.saved = entity.saved
                                        self?.finished = entity.finished
                                        self?.view?.reloadData()
                                    },
                                    failure: { message in

                                        print(message)
                                    }
        )
    }

    func viewWillAppear() {

        self.interactor.getBenefits(
            success: { [weak self] entity in

                self?.responseEntity = entity
                self?.bought = entity.bought
                self?.saved = entity.saved
                self?.finished = entity.finished
                self?.view?.reloadData()
            },
            failure: { message in

                print(message)
            }
        )
    }
}
