//
//  BenefitDescriptionBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 10.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IBenefitDescriptionBuilder {
    func build(_ dependency: BenefitDescriptionDependency) -> IBenefitDescriptionRouter
}

final class BenefitDescriptionBuilder: IBenefitDescriptionBuilder {
    
    func build(_ dependency: BenefitDescriptionDependency) -> IBenefitDescriptionRouter {
        
        let view = BenefitDescriptionView()
        let router = BenefitDescriptionRouter(view: view, parentController: dependency.parentController)
        let interactor = BenefitDescriptionInteractor(benefitEntity: dependency.benefitsEntity)
        let presenter =  BenefitDescriptionPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter

        return router
    }
}
