//
//  ProfileView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 20.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import UICircularProgressRing
import Charts

protocol IProfileView: AnyObject {
    
    func reloadData()
}

final class ProfileView: BUContentViewController {

    // MARK: - Public variables

    var presenter: IProfilePresenter!

    // MARK: - Private variables

    private var refreshContol: UIRefreshControl!
    private var scrollView: UIScrollView!
    private var scrollContentView: UIView!
    private var headerView: ProfileHeaderView!
    private var infoContainer: ProfileInfoContainer!
    private var actionsChartsContainer: ProfileActionsChartsContainer!
    private var ahievementsContainer: ProfileAhievementsView!

    // MARK: - Life cycle

    override func loadView() {
        
        self.view = UIView()
        
        self.scrollView = self.configureScrollView()
        self.refreshContol = self.configureRefeshControl()
        self.scrollView.refreshControl = self.refreshContol
        self.scrollContentView = self.configureScrollContentView()

        self.headerView = ProfileHeaderView(frame: .zero)
        self.infoContainer = ProfileInfoContainer(frame: .zero)
        self.ahievementsContainer = ProfileAhievementsView(frame: .zero)
        self.actionsChartsContainer = ProfileActionsChartsContainer(
            selectedCategory: .tasks,
            onCategorySelection: { [weak self] _ in
                
                self?.actionsChartsContainer.reloadData()
            })

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.scrollContentView)
        
        [self.headerView,
         self.infoContainer,
         self.actionsChartsContainer,
         self.ahievementsContainer].forEach { self.scrollContentView.addSubview($0) }

        self.scrollView.snp.makeConstraints { make in
            
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.scrollContentView.snp.makeConstraints { make in
            
            make.width.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        }
        
        self.headerView.snp.makeConstraints { make in
            
            make.top.leading.trailing.equalToSuperview().inset(15.0)
        }

        self.infoContainer.snp.makeConstraints { make in
            
            make.top.equalTo(self.headerView.snp.bottom).offset(15.0)
            make.leading.trailing.equalToSuperview().inset(15.0)
        }

        self.actionsChartsContainer.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.infoContainer.snp.bottom).offset(15.0)
            make.width.equalTo(self.actionsChartsContainer.snp.height)
        }

        self.ahievementsContainer.snp.makeConstraints { make in
            
            make.top.equalTo(self.actionsChartsContainer.snp.bottom).offset(15.0)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.setupAppearance()

        self.headerView.dataSource = self
        self.infoContainer.dataSource = self
        self.actionsChartsContainer.dataSource = self
        self.ahievementsContainer.dataSource = self
        
        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.presenter.refreshData(completion: nil)
    }

    // MARK: - Localication

    override func setupLocalizableContent() {

        self.navigationItem.title = "ui_profile_title".localized
    }

    // MARK: - Setup

    private func setupAppearance() {

        self.view.theme_backgroundColor = Colors.backgroundColor
        self.configureNavigationBar()
    }
    
    // MARK: - Configure
    
    private func configureRefeshControl() -> UIRefreshControl {
        
        let refresh = UIRefreshControl()
        
        refresh.addTarget(self, action: #selector(refreshControlDidTrigger(_:)), for: .valueChanged)
        refresh.tintColor = .systemRed
        
        return refresh
    }
    
    private func configureScrollView() -> UIScrollView {
        
        let scroll = UIScrollView()
        
        scroll.showsVerticalScrollIndicator = false
        scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
        return scroll
    }
    
    private func configureScrollContentView() -> UIView {
        
        let container = UIView()
        
        container.backgroundColor = .clear
        
        return container
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
    
    @objc private func refreshControlDidTrigger(_ sender: UIRefreshControl) {
        
        self.presenter.refreshData {
            
            sender.endRefreshing()
        }
    }
}

// MARK: - IProfileView

extension ProfileView: IProfileView {

    func reloadData() {
        
        self.headerView.reloadData()
        self.infoContainer.reloadData()
        self.actionsChartsContainer.reloadData()
        self.ahievementsContainer.reloadData()
    }
}

// MARK: - ProfileHeaderViewDataSource

extension ProfileView: ProfileHeaderViewDataSource {
    func iconForProfileHeaderView(_ profileHeaderView: ProfileHeaderView) -> UIImage? {
        
        return AssetsHelper.shared.image(.usernameIcon)?.withRenderingMode(.alwaysTemplate)
    }

    func profileHeaderView(_ profileHeaderView: ProfileHeaderView,
                           userInfoFor type: ProfileHeaderView.UserInfoType) -> String? {
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
    func profileInfoContainer(_ container: ProfileInfoContainer,
                              valueFor type: ProfileInfoContainer.InfoType) -> String {
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

// MARK: - ProfileActionsChartsContainerDataSource

extension ProfileView: ProfileActionsChartsContainerDataSource {
    
    func actionsCharts(_ charts: ProfileActionsChartsContainer,
                       needsDataFor category: ProfileActionsChartsContainer.Category) -> PieChartData {
        
        return self.presenter.actionsChartData(for: category)
    }
}
