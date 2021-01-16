//
//  ProfileView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 20.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import UICircularProgressRing

protocol IProfileView: AnyObject {
    
    func reloadData()
}

final class ProfileView: BUContentViewController {

    // MARK: - Public variables

    var presenter: IProfilePresenter!

    // MARK: - Private variables

    private var headerView: ProfileHeaderView!
    private var infoContainer: ProfileInfoContainer!
    private var progressContainer: ProfileProgressContainer!
    private var ahievementsContainer: ProfileAhievementsView!

    // MARK: - Life cycle

    override func loadView() {

        self.view = UIView()

        self.headerView = ProfileHeaderView(frame: .zero)
        self.infoContainer = ProfileInfoContainer(frame: .zero)
        self.progressContainer = ProfileProgressContainer(frame: .zero)
        self.ahievementsContainer = ProfileAhievementsView(frame: .zero)

        [self.headerView,
         self.infoContainer,
         self.progressContainer,
         self.ahievementsContainer].forEach { self.view.addSubview($0) }

        self.headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(10.0)
        }

        self.infoContainer.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom).offset(10.0)
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.height.equalTo(50.0)
        }

        self.progressContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.infoContainer.snp.bottom).offset(10.0)
        }

        self.ahievementsContainer.snp.makeConstraints { make in
            make.top.equalTo(self.progressContainer.snp.bottom).offset(10.0)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10.0)
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.configureAppearance()

        self.headerView.dataSource = self
        self.infoContainer.dataSource = self
        self.progressContainer.dataSource = self
        self.ahievementsContainer.dataSource = self

        self.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.presenter.viewWillAppear()
        super.viewWillAppear(animated)
    }

    // MARK: - Localication

    override func setupLocalizableContent() {

        self.navigationItem.title = "ui_profile_title".localized
    }

    // MARK: - Configurations

    private func configureAppearance() {

        self.view.theme_backgroundColor = Colors.backgroundColor
        self.configureNavigationBar()
    }

    private func configureNavigationBar() {

        let infoButton = UIButton(type: .infoLight)
        infoButton.theme_tintColor = Colors.navBarIconColor
        infoButton.addTarget(self, action: #selector(infoNavigationItemTapped), for: .touchUpInside)
        let infoNavigationItem = UIBarButtonItem(customView: infoButton)

        self.navigationItem.rightBarButtonItems = [infoNavigationItem]
    }

    // MARK: - Selectors

    @objc private func infoNavigationItemTapped() {
        self.presenter.handleInfoButtonTapped()
    }
}

// MARK: - IProfileView

extension ProfileView: IProfileView {

    func reloadData() {
        self.headerView.reloadData()
        self.infoContainer.reloadData()
        self.progressContainer.reloadData()
        self.ahievementsContainer.reloadData()
    }
}

// MARK: - ProfileHeaderViewDataSource

extension ProfileView: ProfileHeaderViewDataSource {
    func iconForProfileHeaderView(_ profileHeaderView: ProfileHeaderView) -> UIImage? {
        return AssetsHelper.shared.image(.usernameIcon)
    }

    func profileHeaderView(_ profileHeaderView: ProfileHeaderView, userInfoFor type: ProfileHeaderView.UserInfoType) -> String? {
        switch type {
        case .name:
            return self.presenter.name
        case .email:
            return self.presenter.email
        case .organization:
            return self.presenter.organization
        }
    }
}

// MARK: - ProfileInfoContainerDataSource

extension ProfileView: ProfileInfoContainerDataSource {
    func profileInfoContainer(_ container: ProfileInfoContainer, valueFor type: ProfileInfoContainer.InfoType) -> String {
        switch type {
        case .done:
            return self.presenter.doneTasks
        case .rest:
            return self.presenter.restBalls
        case .spend:
            return self.presenter.allSpendBalls
        }
    }
}

// MARK: - ProfileProgressContainerDataSource

extension ProfileView: ProfileProgressContainerDataSource {
    func profileProgressContainer(_ container: ProfileProgressContainer, progressFor type: ProfileProgressContainer.ProgressType) -> CGFloat {

        switch type {
        case .all:
            return self.presenter.donePercent
        case .lastMonth:
            return self.presenter.ballsPercent
        case .lastWeek:
            return self.presenter.activatedCouponsPercent
        case .today:
            return self.presenter.spentBallsPercent
        }
    }
}

// MARK: - ProfileAhievementsViewDataSource

extension ProfileView: ProfileAhievementsViewDataSource {
    func profileAhievementsView(_ profileAhievementsView: ProfileAhievementsView, infoFor type: ProfileAhievementsView.InfoType, at index: Int) -> String? {

        switch type {
        case .title:
            return self.presenter.archiveTitle(for: index)
        case .description:
            return self.presenter.archiveDescription(for: index)
        }
    }

    func numberOfItemsInprofileAhievementsView(_ profileAhievementsView: ProfileAhievementsView) -> Int {

        return self.presenter.archivesCount()
    }
}
