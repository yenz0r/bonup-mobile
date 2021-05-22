//
//  BenefitDescriptionPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 10.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IBenefitDescriptionPresenter: AnyObject {
    func viewDidLoad()
}

final class BenefitDescriptionPresenter {

    private weak var view: IBenefitDescriptionView?
    private let interactor: IBenefitDescriptionInteractor
    private let router: IBenefitDescriptionRouter

    init(view: IBenefitDescriptionView?,
         interactor: IBenefitDescriptionInteractor,
         router: IBenefitDescriptionRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IBenefitsPresenter implementation

extension BenefitDescriptionPresenter: IBenefitDescriptionPresenter {

    func viewDidLoad() {

        let title = self.interactor.benefitTitle
        let description = self.interactor.benefitDescription
        let imageLink = self.interactor.benefitImageLink

        self.view?.setupTitle(title)
        self.view?.setupDescription(description)
        self.view?.setupQrCode(self.interactor.codeLine)
        self.view?.setupImage(imageLink)
    }
}
