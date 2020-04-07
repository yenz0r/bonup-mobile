//
//  ApplicationContentRouter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IApplicationContentRouter: AnyObject {
    func start(_ completion: (() -> Void)?)
    func stop(_ completion: (() -> Void)?)
}

final class ApplicationContentRouter {

    // MARK: - Private variables

    private let parentWindow: UIWindow?
    private var view: UIViewController?

    // MARK: - Initialization

    init(view: UIViewController?, parentWindow: UIWindow?) {
        self.view = view
        self.parentWindow = parentWindow
    }
}

// MARK: - IApplicationContentRouter

extension ApplicationContentRouter: IApplicationContentRouter {
    func start(_ completion: (() -> Void)?) {
        guard let view = self.view, let tabBarController = view as? BUTabBarController else { return }

        var viewControllers = [UIViewController]()
        let colors: [UIColor] = [.red, .green, .blue, .orange, .purple]

        for color in colors {
            let viewController = UIViewController()
            viewController.view.backgroundColor = color
            viewControllers.append(viewController)
            viewController.tabBarItem = UITabBarItem(
                title: "ui_tasks_title".localized,
                image: AssetsHelper.shared.image(.tasksUnselectedIcon),
                selectedImage: AssetsHelper.shared.image(.tasksSelectedIcon)
            )
        }

        tabBarController.viewControllers = viewControllers
        self.parentWindow?.rootViewController = tabBarController

        completion?()
    }

    func stop(_ completion: (() -> Void)?) {
        guard let view = view, let tabBarController = view as? UITabBarController else {
            return
        }

        // NOTE: - Removed links cycle on closing
        tabBarController.viewControllers = []

        completion?()
    }
}

