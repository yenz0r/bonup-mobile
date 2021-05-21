//
//  SettingsParamsRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ISettingsParamsRouter {

    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
}

final class SettingsParamsRouter {

    private var view: SettingsParamsView?
    private var parentNavigationController: UINavigationController

    init(view: SettingsParamsView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICategoriesRouter implementation

extension SettingsParamsRouter: ISettingsParamsRouter {

    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentNavigationController.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentNavigationController.popViewController(animated: true)
        self.view = nil

        completion?()
    }
}
