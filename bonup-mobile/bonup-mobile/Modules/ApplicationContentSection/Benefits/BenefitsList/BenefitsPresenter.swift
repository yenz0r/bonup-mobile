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
    
    func refreshData()

    var savedBenfits: [ActualBenefitEntity] { get }
    var boughtBenfits: [ActualBenefitEntity] { get }
    var finishedBenefits: [FinishedBenefitEntity] { get }

    var pages: [String] { get }
}

final class BenefitsPresenter {

    // MARK: - Private variables
    
    private weak var view: IBenefitsView?
    private let interactor: IBenefitsInteractor
    private let router: IBenefitsRouter

    // MARK: - Model variables
    
    private var responseEntity: BenefitsResponseEntity?
    
    // MARK: - Data sequenses variables
    
    private var current: [ActualBenefitEntity]?
    private var bought: [ActualBenefitEntity]?
    private var finished: [FinishedBenefitEntity]?

    // MARK: - State variables
    
    private var isFirstRefresh = true
    
    // MARK: - Init
    
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
            "ui_new_title",
            "ui_selected_title",
            "ui_used_title"
        ]
    }

    var savedBenfits: [ActualBenefitEntity] {
        return self.current ?? []
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

        self.router.show(.benefitDescription(entity:boughtBenefits[index],
                                             completion: { [weak self] in
                                                
                                                self?.isFirstRefresh = true
                                                self?.refreshData()
                                             }))
    }

    func handleBuyBenefit(for index: Int) {

        guard let saved = self.current else { return }

        let id = saved[index].id

        self.interactor.buyBenefits(id: id,
                                    success: { [weak self] entity in

                                        self?.refreshData()
                                    },
                                    failure: { [weak self] message in

                                        DispatchQueue.main.async {
                                            
                                            self?.router.show(.showErrorAlert(message))
                                        }
                                    }
        )
    }

    func refreshData() {
        
        self.interactor.getBenefits(
            withLoader: true,
            success: { [weak self] entity in

                self?.responseEntity = entity
                self?.bought = entity.bought
                self?.current = entity.current
                self?.finished = entity.finished
                
                DispatchQueue.main.async {
                 
                    self?.view?.stopRefreshControls()
                    self?.view?.reloadData()
                }
            },
            failure: { message in
                
                print(message)
            }
        )
        
        if self.isFirstRefresh {
            
            self.isFirstRefresh.toggle()
        }
    }
}
