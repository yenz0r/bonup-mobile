//
//  OrganizationControlPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IOrganizationControlPresenter: AnyObject {

    func numberOfControls() -> Int
    func title(for index: Int) -> String
    func icon(for index: Int) -> UIImage?
    func handleScanResult(_ result: String, at index: Int)
}

final class OrganizationControlPresenter {

    private weak var view: IOrganizationControlView?
    private let interactor: IOrganizationControlInteractor
    private let router: IOrganizationControlRouter

    private let titles = [
        "ui_check_task".localized,
        "ui_check_benefit".localized,
//        "ui_add_task".localized,
//        "ui_add_benefit".localized
    ]

    private let icons = [
        AssetsHelper.shared.image(.settingsRateUs),
        AssetsHelper.shared.image(.settingsHelp)
    ]

    init(view: IOrganizationControlView?, interactor: IOrganizationControlInteractor, router: IOrganizationControlRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IOrganizationControlPresenter implementation

extension OrganizationControlPresenter: IOrganizationControlPresenter {
    func numberOfControls() -> Int {

        return 2
    }

    func title(for index: Int) -> String {

        return self.titles[index]
    }

    func icon(for index: Int) -> UIImage? {

        return self.icons[index]
    }

    func handleScanResult(_ result: String, at index: Int) {

        if index == 0 {

            self.interactor.resolveTask(qrCode: result, block: { [weak self] isSuccess, message in

                self?.router.show(.showResultAlert(message))
            })
        } else {

            self.interactor.activateCoupon(qrCode: result, block: { [weak self] isSuccess, message in

                self?.router.show(.showResultAlert(message))
            })
        }
    }
}
