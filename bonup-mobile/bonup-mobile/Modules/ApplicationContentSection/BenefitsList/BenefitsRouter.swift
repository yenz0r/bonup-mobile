//
//  BenefitsRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IBenefitsRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: BenefitsRouter.BenefitsRouterScenario)
}

final class BenefitsRouter {
    enum BenefitsRouterScenario {
        case benefitDescription(ActualBenefitEntity)
        case showHelpAlert
    }

    private var view: BenefitsView?
    private var parentNavigationController: UINavigationController

    init(view: BenefitsView?, parentNavigationController: UINavigationController) {
        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICategoriesRouter implementation

extension BenefitsRouter: IBenefitsRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentNavigationController.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentNavigationController.popViewController(animated: true)
        completion?()
        self.view = nil
    }

    func show(_ scenario: BenefitsRouterScenario) {
        guard let view = self.view else { return }

        switch scenario {

        case .benefitDescription(let benefit):

            let dependency = BenefitDescriptionDependency(
                parentController: view,
                benefitsEntity: benefit
            )
            let builder = BenefitDescriptionBuilder()
            let router = builder.build(dependency)
            router.start(nil)

        case .showHelpAlert:

            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_benefits_title".localized,
                description: "ui_benefits_help".localized,
                from: view,
                completion: nil
            )
        }
    }
}
