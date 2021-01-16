//
//  CompanySearchRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

protocol ICompaniesSearchRouter {

    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
}

final class CompaniesSearchRouter {

    private var view: CompaniesSearchView?
    private var parentNavigationController: UINavigationController

    init(view: CompaniesSearchView?, parentNavigationController: UINavigationController) {

        self.view = view
        self.parentNavigationController = parentNavigationController
    }
}

// MARK: - ICategoriesRouter implementation

extension CompaniesSearchRouter: ICompaniesSearchRouter {

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
