//
//  CompanyStatisticsRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 2.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompanyStatisticsRouter {

    func start(startCompletion: (() -> Void)?)
    func stop(withPop: Bool, stopCompetion: (() -> Void)?)
    func show(_ scenario: CompanyStatisticsRouter.RouterScenario)
}

final class CompanyStatisticsRouter {

    enum RouterScenario {
        
        case share(UIImage)
        case showResultAlert(String)
        case showActionsList([OrganizationActionEntity], CompanyActionsListDependency.ContentType)
    }

    private var view: CompanyStatisticsView?
    private var parentNavigationController: UINavigationController

    init(view: CompanyStatisticsView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICompanyCustomPacketRouter implementation

extension CompanyStatisticsRouter: ICompanyStatisticsRouter {

    func start(startCompletion: (() -> Void)?) {

        guard let view = self.view else { return }

        self.parentNavigationController.pushViewController(view, animated: true)
    }

    func stop(withPop: Bool, stopCompetion: (() -> Void)?) {
        
        if withPop {
        
            self.parentNavigationController.popViewController(animated: true)
        }
        
        self.view = nil
    }

    func show(_ scenario: RouterScenario) {
        
        guard let view = self.view else { return }
        
        switch scenario {
        
        case .share(let image):
            
            let imageShare = [image]
            let activityViewController = UIActivityViewController(activityItems: imageShare,
                                                                  applicationActivities: nil)
            activityViewController.title = "Bonup Platform"
            if #available(iOS 13.0, *) {
                
                activityViewController.overrideUserInterfaceStyle = ThemeColorsManager.shared.currentTheme == .dark ? .dark : .light
            }
            
            activityViewController.popoverPresentationController?.sourceView = view.view
            view.present(activityViewController, animated: true, completion: nil)
            
        case .showResultAlert(let message):
            AlertsFactory.shared.infoAlert(
                for: .error,
                title: "ui_help_title".localized,
                description: message,
                from: view,
                completion: nil
            )
            
        case .showActionsList(let actions, let contentType):
            
            let dependecy = CompanyActionsListDependency(
                parentNavigationController: self.parentNavigationController,
                contentType: contentType,
                contentMode: .show,
                actions: actions
            )
            let builder = CompanyActionsListBuilder()
            let router: ICompanyActionsListRouter = builder.build(dependecy)
            
            router.start(nil)
        }
    }
}

