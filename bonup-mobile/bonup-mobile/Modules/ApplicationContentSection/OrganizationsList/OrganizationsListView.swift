//
//  OrganizationsView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IOrganizationsListView: AnyObject {

    func reloadData()
    func stopRefreshControl()
}

final class OrganizationsListView: BUContentViewController {

    // MARK: - Public variables

    var presenter: IOrganizationsListPresenter!

    // MARK: - User interface variables

    private var refreshControl: UIRefreshControl!
    private var collectionView: UICollectionView!
    private var addButton: OrganizationsListAddButton!
    private var emptyContainer: BUEmptyContainer!

    // MARK: - Life cycle

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.setupAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        self.presenter.refreshData()
    }

    // MARK: - Localization

    override func setupLocalizableContent() {

        self.navigationItem.title = "ui_organization_title".localized
        self.emptyContainer.descriptionText = "ui_empty_organizations_title".localized
    }

    // MARK: - Setup

    private func setupSubviews() {

        self.collectionView = self.configureCollectionView()
        self.refreshControl = self.configureRefreshControl()
        self.collectionView.refreshControl = self.refreshControl
        self.addButton = OrganizationsListAddButton { [weak self] in

            self?.presenter.handleAddButtonTap()
        }
        self.emptyContainer = BUEmptyContainer()
        self.emptyContainer.image = AssetsHelper.shared.image(.emptyTasksListIcon)

        self.view.addSubview(self.addButton)
        self.addButton.snp.makeConstraints { make in
            make.top.centerX.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.addButton.snp.bottom).offset(10)
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(10.0)
        }

        self.view.addSubview(self.emptyContainer)
        self.emptyContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(100)
        }
    }

    private func setupAppearance() {

        self.view.theme_backgroundColor = Colors.backgroundColor
    }
    
    // MARK: - Configurations

    private func configureRefreshControl() -> UIRefreshControl {
        
        let refresh = UIRefreshControl()
        
        refresh.addTarget(self, action: #selector(self.refreshControlDidTrigger(_:)), for: .valueChanged)
        refresh.tintColor = .systemRed
        
        return refresh
    }

    private func configureCollectionView() -> UICollectionView {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
        
        collectionView.register(
            OrganizationsListCell.self,
            forCellWithReuseIdentifier: OrganizationsListCell.reuseId
        )

        collectionView.backgroundColor = .clear

        return collectionView
    }
    
    // MARK: - Selectors
    
    @objc private func refreshControlDidTrigger(_ sender: UIRefreshControl) {
        
        self.presenter.refreshData()
    }
}

// MARK: - UICollectionViewDelegate

extension OrganizationsListView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.presenter.handleShowOgranizationControl(for: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource

extension OrganizationsListView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = self.presenter.numberOfOrganizations()

        self.emptyContainer.isHidden = num != 0
        return num
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrganizationsListCell.reuseId, for: indexPath) as! OrganizationsListCell

        cell.titleText = self.presenter.title(for: indexPath.row)
        cell.imageLink = self.presenter.imagePath(for: indexPath.row)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OrganizationsListView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.collectionView.bounds.size.width - 40.0, height: 150.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

// MARK: - IOrganizationsListView

extension OrganizationsListView: IOrganizationsListView {

    func reloadData() {

        self.collectionView.reloadData()
    }
    
    func stopRefreshControl() {
        
        self.refreshControl.endRefreshing()
    }
}
