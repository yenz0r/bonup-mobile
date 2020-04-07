//
//  TermsAndConditionsPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 07.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ITermsAndConditionsPresenter {
    func handleDoneButtonTap()
}

final class TermsAndConditionsPresenter {
    private weak var view: ITermsAndConditionsView?
    private let router: ITermsAndConditionsRouter

    init(view: ITermsAndConditionsView?, router: ITermsAndConditionsRouter) {
        self.view = view
        self.router = router
    }
}

// MARK: - ITermsAndConditionsPresenter implementation

extension TermsAndConditionsPresenter: ITermsAndConditionsPresenter {

    func handleDoneButtonTap() {
        self.router.stop(nil)
    }

}


