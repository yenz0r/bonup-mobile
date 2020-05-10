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

        let qrCodeImage = QRcodeManager.shared.createQRFromString(
            str: self.interactor.codeLine
        )
        let title = self.interactor.benefitTitle
        let description = self.interactor.benefitDescription

        self.view?.setupTitle(title)
        self.view?.setupDescription(description)
        self.view?.setupQrCodeImage(qrCodeImage)
    }
}
