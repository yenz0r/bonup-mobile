//
//  BenefitDescriptionRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 10.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IBenefitDescriptionRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
}

final class BenefitDescriptionRouter {

    private var view: BenefitDescriptionView?
    private var parentController: UIViewController

    init(view: BenefitDescriptionView?, parentController: UIViewController) {
        self.view = view
        self.parentController = parentController
    }
}

// MARK: - ICategoriesRouter implementation

extension BenefitDescriptionRouter: IBenefitDescriptionRouter {
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
}

