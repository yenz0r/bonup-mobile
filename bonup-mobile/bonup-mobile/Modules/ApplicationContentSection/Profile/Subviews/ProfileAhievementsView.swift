//
//  ProfileAhievementsView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 23.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ProfileAhievementsViewDataSource: AnyObject {
    func numberOfItemsInprofileAhievementsView(_ profileAhievementsView: ProfileAhievementsView) -> Int
    func profileAhievementsView(_ profileAhievementsView: ProfileAhievementsView, infoFor type: ProfileAhievementsView.InfoType, at index: Int) -> String?
}

final class ProfileAhievementsView: UIView {

    enum InfoType {
        case title, description
    }

    // MARK: - Public variables

    var dataSource: ProfileAhievementsViewDataSource!

    // MARK: - Private variables

    private var collectionView: UICollectionView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    func reloadData() {
        self.collectionView.reloadData()
    }

    // MARK: - Setup subviews

    private func setupSubviews() {
        self.collectionView = self.configureCollectionView()

        self.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configure

    private func configureCollectionView() -> UICollectionView {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(
            ProfileAhievementsCell.self,
            forCellWithReuseIdentifier: ProfileAhievementsCell.reuseId
        )

        return collectionView
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileAhievementsView: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource

extension ProfileAhievementsView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.numberOfItemsInprofileAhievementsView(self)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileAhievementsCell.reuseId,
            for: indexPath
        )

        guard let ahievementetsCell = cell as? ProfileAhievementsCell else {
            return cell
        }

        ahievementetsCell.title = self.dataSource.profileAhievementsView(
            self,
            infoFor: .title,
            at: indexPath.row
        )
        ahievementetsCell.descriptionText = self.dataSource.profileAhievementsView(
            self,
            infoFor: .description,
            at: indexPath.row
        )

        return ahievementetsCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileAhievementsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}