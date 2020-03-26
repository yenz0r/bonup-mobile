//
//  AlertsFactory.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import PMAlertController
import SwiftSpinner

final class AlertsFactory {

    enum AlertType {
        case error
    }

    enum LoadinAlertAction {
        case show(message: String)
        case showWithDuration(duration: Double, message: String)
        case hide
    }

    static let shared = AlertsFactory()

    private init() { }

    func infoAlert(for type: AlertType,
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

            controller.present(alertVC, animated: true, completion: nil)
        }

    }

    func loadingAlert(_ action: LoadinAlertAction) {
        DispatchQueue.main.async {

            switch action {
            case .show(let message):
                SwiftSpinner.show(message)
            case .showWithDuration(let duration, let message):
                SwiftSpinner.show(duration: duration, title: message)
            case .hide:
                SwiftSpinner.hide()
            }

        }
    }
}
