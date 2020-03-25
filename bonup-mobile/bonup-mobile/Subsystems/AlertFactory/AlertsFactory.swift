//
//  AlertsFactory.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import PMAlertController

final class AlertsFactory {

    enum AlertType {
        case error, loading
    }

    static let shared = AlertsFactory()

    private init() { }

    func showInfoAlert(for type: AlertType,
                       title: String,
                       description: String,
                       from controller: UIViewController,
                       completion: (() -> Void)?) {
        var alertVC: PMAlertController

        switch type {
        case .error:
            alertVC = PMAlertController(
                title: title,
                description: description,
                image: AssetsHelper.shared.image(.flagIcon),
                style: .alert
            )

            alertVC.addAction(
                PMAlertAction(
                    title: "ui_ok".localized,
                    style: .default,
                    action: {
                        completion?()
                    }
                )
            )
        case .loading:
            alertVC = PMAlertController(
                title: title,
                description: description,
                image: AssetsHelper.shared.image(.flagIcon),
                style: .alert
            )
        }

        controller.present(alertVC, animated: true, completion: nil)
    }
}
