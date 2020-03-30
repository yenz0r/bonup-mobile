//
//  CategoriesRouter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ICategoriesRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
    func show(_ scenario: CategoriesRouter.CategoriesRouterScenario)
}

final class CategoriesRouter {
    enum CategoriesRouterScenario {
        case openApplication
    }

    private var view: CategoriesView?
    private var parentController: UIViewController?

    init(view: CategoriesView?, parentController: UIViewController?) {
        self.view = view
        self.parentController = parentController
    }
}

// MARK: - ICategoriesRouter implementation

extension CategoriesRouter: ICategoriesRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view else { return }

        view.modalPresentationStyle = .fullScreen

        self.parentController?.navigationController?.pushViewController(view, animated: true)
        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        self.parentController?.navigationController?.popToRootViewController(animated: true)
        completion?()
        self.view = nil
    }

    func show(_ scenario: CategoriesRouterScenario) {

        switch scenario {
        case .openApplication:
            AppRouter.shared.present(.openApplication)
        }

    }

}
