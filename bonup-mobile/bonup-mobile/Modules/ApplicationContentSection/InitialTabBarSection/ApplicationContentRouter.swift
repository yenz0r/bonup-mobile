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

        // taskSelection
        let taskSelectionNavigationController = BUNavigationController()
        taskSelectionNavigationController.setupTabBarItem(
            with: "ui_tasks_title".localized,
            unselectedImage: AssetsHelper.shared.image(.tasksUnselectedIcon),
            selectedImage: AssetsHelper.shared.image(.tasksSelectedIcon)
        )
        let taskSelectionDependency = TaskSelectionDependency(
            parentNavigationController: taskSelectionNavigationController
        )
        let taskSelectionBuilder = TaskSelectionBuilder()
        let taskSelectionRouter = taskSelectionBuilder.build(taskSelectionDependency)
        taskSelectionRouter.start(nil)

        // settings
        let settingsNavigationController = BUNavigationController()
        settingsNavigationController.setupTabBarItem(
            with: "ui_settings_title".localized,
            unselectedImage: AssetsHelper.shared.image(.profileUnselectedIcon),
            selectedImage: AssetsHelper.shared.image(.profileSelectedIcon)
        )
        let settingsDependency = SettingsDependency(
            parentNavigationController: settingsNavigationController
        )
        let settingsBuilder = SettingsBuilder()
        let settingsRouter = settingsBuilder.build(settingsDependency)
        settingsRouter.start(nil)

        var viewControllers = [UIViewController]()
        viewControllers.append(taskSelectionNavigationController)
        viewControllers.append(settingsNavigationController)

        let colors: [UIColor] = [.green, .orange, .purple]

        for (index, color) in colors.enumerated() {
            let viewController = UIViewController()
            viewController.view.backgroundColor = color
            viewControllers.append(viewController)
            viewController.tabBarItem = UITabBarItem(
                title: "\(index)".localized,
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

