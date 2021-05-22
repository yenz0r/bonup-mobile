//
//  BenefitDescriptionRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 10.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IBenefitDescriptionRouter {
    func start(stopCompletion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
}

final class BenefitDescriptionRouter {

    // MARK: - Private variables
    
    private var view: BenefitDescriptionView?
    private var parentController: UIViewController
    private var onTerminate: (() -> Void)?

    // MARK: - Init
    
    init(view: BenefitDescriptionView?, parentController: UIViewController) {
        
        self.view = view
        self.parentController = parentController
    }
}

// MARK: - ICategoriesRouter implementation

extension BenefitDescriptionRouter: IBenefitDescriptionRouter {
    
    func start(stopCompletion: (() -> Void)?) {
        
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentController.navigationController?.pushViewController(view, animated: true)
        
        self.onTerminate = stopCompletion
    }

    func stop(_ completion: (() -> Void)?) {
        
        self.parentController.navigationController?.popViewController(animated: true)
        
        completion?()
        self.onTerminate?()
        
        self.view = nil
    }
}

