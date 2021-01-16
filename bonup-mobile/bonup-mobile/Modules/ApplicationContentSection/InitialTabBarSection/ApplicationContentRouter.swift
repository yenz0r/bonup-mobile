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
        let taskSelectionContainer = self.configureTaskSelectionContainer()

        // settings
        let settingsContainer = self.configureSettingsContainer()

        // profile
        let profileContainer = self.configureProfileContainer()

        // benefits
        let benefitsContainer = self.configureBenefitsContainer()

        // organizations
        let organizationsContainer = self.configureOrganizationsContainer()

        let viewControllers = [
            taskSelectionContainer,
            benefitsContainer,
            profileContainer,
            organizationsContainer,
            settingsContainer
        ]

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

// MARK: - Helpers

extension ApplicationContentRouter {

    func configureBenefitsContainer() -> BUNavigationController {
        let benefitsNavigationController = BUNavigationController()
        benefitsNavigationController.setupTabBarItem(
            with: "ui_benefits_title",
            unselectedImage: AssetsHelper.shared.image(.actionsUnselectedIcon),
            selectedImage: AssetsHelper.shared.image(.actionsSelectedIcon)
        )

        let benefitsDependency = BenefitsDependency(
            parentNavigationController: benefitsNavigationController
        )
        let benefitsBuilder = BenefitsBuilder()
        let benefitsRouter = benefitsBuilder.build(benefitsDependency)
        benefitsRouter.start(nil)

        return benefitsNavigationController
    }

    func configureTaskSelectionContainer() -> BUNavigationController {
        let taskSelectionNavigationController = BUNavigationController()
        taskSelectionNavigationController.setupTabBarItem(
            with: "ui_tasks_title",
            unselectedImage: AssetsHelper.shared.image(.tasksUnselectedIcon),
            selectedImage: AssetsHelper.shared.image(.tasksSelectedIcon)
        )

        let taskSelectionDependency = TaskSelectionDependency(
            parentNavigationController: taskSelectionNavigationController
        )
        let taskSelectionBuilder = TaskSelectionBuilder()
        let taskSelectionRouter = taskSelectionBuilder.build(taskSelectionDependency)
        taskSelectionRouter.start(nil)

        return taskSelectionNavigationController
    }

    func configureSettingsContainer() -> BUNavigationController {
        let settingsNavigationController = BUNavigationController()
        settingsNavigationController.setupTabBarItem(
            with: "ui_settings_title",
            unselectedImage: AssetsHelper.shared.image(.profileUnselectedIcon),
            selectedImage: AssetsHelper.shared.image(.profileSelectedIcon)
        )

        let settingsDependency = SettingsDependency(
            parentNavigationController: settingsNavigationController
        )
        let settingsBuilder = SettingsBuilder()
        let settingsRouter = settingsBuilder.build(settingsDependency)
        settingsRouter.start(nil)

        return settingsNavigationController
    }

    func configureOrganizationsContainer() -> BUNavigationController {
        let organizationsNavigationController = BUNavigationController()
        organizationsNavigationController.setupTabBarItem(
            with: "ui_organization_title",
            unselectedImage: AssetsHelper.shared.image(.organizationUnselectedIcon),
            selectedImage: AssetsHelper.shared.image(.organizationSelectedIcon)
        )

        let organizationsDependency = OrganizationsListDependency(
            parentNavigationController: organizationsNavigationController
        )
        let organizationsBuilder = OrganizationsListBuilder()
        let organizationsRouter = organizationsBuilder.build(organizationsDependency)
        organizationsRouter.start(nil)

        return organizationsNavigationController
    }

    func configureProfileContainer() -> BUNavigationController {
        let profileNavigationController = BUNavigationController()
        profileNavigationController.setupTabBarItem(
            with: "ui_profile_title",
            unselectedImage: AssetsHelper.shared.image(.settingsHelp),
            selectedImage: AssetsHelper.shared.image(.settingsHelp)
        )

        let profileDependency = ProfileDependency(
            parentNavigationController: profileNavigationController
        )
        let profileBuilder = ProfileBuilder()
        let profileRouter = profileBuilder.build(profileDependency)
        profileRouter.start(nil)

        return profileNavigationController
    }
}
