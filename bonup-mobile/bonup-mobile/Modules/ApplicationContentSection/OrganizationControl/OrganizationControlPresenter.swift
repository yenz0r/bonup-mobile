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

    func handleAddTask(name: String, deskriptionText: String, count: Int, type: Int)
    func handleAddBenefit(name: String, deskriptionText: String, count: Int, type: Int)
}

final class OrganizationControlPresenter {

    private weak var view: IOrganizationControlView?
    private let interactor: IOrganizationControlInteractor
    private let router: IOrganizationControlRouter

    private let titles = [
        "ui_check_task".localized,
        "ui_check_benefit".localized,
        "ui_add_task".localized,
        "ui_add_benefit".localized
    ]

    private let icons = [
        AssetsHelper.shared.image(.settingsRateUs),
        AssetsHelper.shared.image(.settingsHelp),
        AssetsHelper.shared.image(.settingsCategory),
        AssetsHelper.shared.image(.settingsRateUs)
    ]

    init(view: IOrganizationControlView?, interactor: IOrganizationControlInteractor, router: IOrganizationControlRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IOrganizationControlPresenter implementation

extension OrganizationControlPresenter: IOrganizationControlPresenter {
    func handleAddTask(name: String, deskriptionText: String, count: Int, type: Int) {
        self.interactor.addTask(
            name: name,
            descriptionText: deskriptionText,
            count: count,
            type: type,
            success: { message in
                self.router.show(.showResultAlert(message))
            },
            failure: { message in
                self.router.show(.showResultAlert(message))
            }
        )
    }

    func handleAddBenefit(name: String, deskriptionText: String, count: Int, type: Int) {
        self.interactor.addBenefit(
            name: name,
            descriptionText: deskriptionText,
            count: count,
            type: type,
            success: { message in
                self.router.show(.showResultAlert(message))
        },
            failure: { message in
                self.router.show(.showResultAlert(message))
        }
        )
    }

    func numberOfControls() -> Int {

        return 4
    }

    func title(for index: Int) -> String {

        return self.titles[index]
    }

    func icon(for index: Int) -> UIImage? {

        return self.icons[index]
    }

    func handleScanResult(_ result: String, at index: Int) {

        switch index {
        case 0:
            self.interactor.resolveTask(qrCode: result, block: { [weak self] isSuccess, message in

                self?.router.show(.showResultAlert(message))
            })
        case 1:
            self.interactor.activateCoupon(qrCode: result, block: { [weak self] isSuccess, message in

                           self?.router.show(.showResultAlert(message))
                       })
        default:
            return
        }
    }
}
