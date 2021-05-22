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
    
    private var loadingAlertsCount = 0

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
            alertVC.alertView.theme_backgroundColor = Colors.profileSectionColor
            alertVC.headerView.theme_backgroundColor = Colors.profileSectionColor
            
            alertVC.alertTitle.theme_textColor = Colors.defaultTextColor
            alertVC.alertTitle.font = .avenirHeavy(20)
            
            alertVC.alertDescription.theme_textColor = Colors.defaultTextColorWithAlpha
            alertVC.alertDescription.font = .avenirRoman(17)

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
                
                self.loadingAlertsCount += 1
                SwiftSpinner.show(message)
                
            case .showWithDuration(let duration, let message):
                SwiftSpinner.show(duration: duration, title: message)
                
            case .hide:
                
                self.loadingAlertsCount -= 1
                
                if self.loadingAlertsCount == 0 {
                
                    SwiftSpinner.hide()
                }
            }

        }
    }
}
