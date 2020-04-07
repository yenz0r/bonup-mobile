//
//  TermsAndConditionsBuilder.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 07.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ITermsAndConditionsBuilder {
    func build(_ dependency: TermsAndConditionsDependency) -> ITermsAndConditionsRouter
}

final class TermsAndConditionsBuilder: ITermsAndConditionsBuilder {
    func build(_ dependency: TermsAndConditionsDependency) -> ITermsAndConditionsRouter {
        
        let view = TermsAndConditionsView()
        let router = TermsAndConditionsRouter(view: view, parentController: dependency.parentViewController)
        let presenter = TermsAndConditionsPresenter(view: view, router: router)
        view.presenter = presenter

        return router
    }
}

