//
//  ApplicationContentBuilder.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IApplicationContentBuilder {
    func build(dependency: ApplicationContentDependency) -> ApplicationContentRouter
}

final class ApplicationContentBuilder { }

// MARK: - ApplicationContentBuilder implementation

extension ApplicationContentBuilder: IApplicationContentBuilder {
    func build(dependency: ApplicationContentDependency) -> ApplicationContentRouter {
        let view = ApplicationContentView()
        let router = ApplicationContentRouter(view: view, parentWindow: dependency.parentWindow)
        return router
    }
}
