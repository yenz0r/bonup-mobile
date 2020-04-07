//
//  TermsAndConditionsRouter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 07.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ITermsAndConditionsRouter {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
}

final class TermsAndConditionsRouter {

    private var view: TermsAndConditionsView?
    private var parentController: UIViewController?

    init(view: TermsAndConditionsView?, parentController: UIViewController?) {
        self.view = view
        self.parentController = parentController
    }
}

// MARK: - ICategoriesRouter implementation

extension TermsAndConditionsRouter: ITermsAndConditionsRouter {
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
}
