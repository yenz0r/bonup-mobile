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
}

final class OrganizationsListView: UIViewController {

    // MARK: - Public variables

    var presenter: IOrganizationsListPresenter!

    // MARK: - User interface variables

    private var collectionView: UICollectionView!
    private var emptyContainerView: UIView!

    // MARK: - Life cycle

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.presenter.viewWillAppear()
    }

    // MARK: - Setup subviews

    private func setupSubviews() {

        self.collectionView = self.configureCollectioView()
        self.emptyContainerView = self.configureEmtpyContainerView()

        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(10.0)
        }

        self.view.addSubview(self.emptyContainerView)
        self.emptyContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(70.0)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20.0)
        }
    }

    // MARK: - Configurations

    private func configureAppearance() {
        self.view.backgroundColor = .white

        self.navigationItem.title = "ui_organization_title".localized
    }

    private func configureCollectioView() -> UICollectionView {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            OrganizationsListCell.self,
            forCellWithReuseIdentifier: OrganizationsListCell.reuseId
        )

        collectionView.backgroundColor = .white

        return collectionView
    }

    private func configureEmtpyContainerView() -> UIView {

        let container = UIView()

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = AssetsHelper.shared.image(.emptyTasksListIcon)

        let label = UILabel()
        label.text = "ui_empty_organizations_title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.avenirRoman(20.0)
        label.textColor = UIColor.black.withAlphaComponent(0.3)

        container.addSubview(imageView)
        container.addSubview(label)

        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10.0)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        return container
    }
}

// MARK: - UICollectionViewDelegate

extension OrganizationsListView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.presenter.handleShowOgranizationControl()
    }
}

// MARK: - UICollectionViewDataSource

extension OrganizationsListView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = self.presenter.numberOfOrganizations()

        self.emptyContainerView.isHidden = num != 0
        return num
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrganizationsListCell.reuseId, for: indexPath) as? OrganizationsListCell

        guard let organizationCell = cell else {

            return UICollectionViewCell()
        }

        organizationCell.titleText = self.presenter.title(for: indexPath.row)
        organizationCell.imageLink = self.presenter.imagePath(for: indexPath.row)

        return organizationCell
    }
}

// MARK: -

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
}
