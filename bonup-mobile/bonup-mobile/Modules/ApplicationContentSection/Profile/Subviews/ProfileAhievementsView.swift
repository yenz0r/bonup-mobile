//
//  ProfileAhievementsView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 23.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

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

    private var sectionTitleLabel: UILabel!
    private var collectionView: UICollectionView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubviews()
        self.setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    func reloadData() {
        
        self.collectionView.reloadData()
        self.collectionView.reloadEmptyDataSet()
    }

    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.theme_backgroundColor = Colors.profileSectionColor
        
        self.layer.cornerRadius = 25
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 4
    }

    private func setupSubviews() {
        
        self.sectionTitleLabel = self.configureSectionTitleLabel()
        self.collectionView = self.configureCollectionView()

        self.addSubview(self.sectionTitleLabel)
        self.addSubview(self.collectionView)

        self.sectionTitleLabel.snp.makeConstraints { make in
            
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(10)
        }
        
        self.collectionView.snp.makeConstraints { make in
            
            make.top.equalTo(self.sectionTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(100)
        }
    }

    // MARK: - Configure
    
    private func configureSectionTitleLabel() -> UILabel {
        
        let label = BULabel()
        
        label.theme_textColor = Colors.defaultTextColorWithAlpha
        label.font = .avenirRoman(15)
        label.nonlocalizedTitle = "ui_profile_archivements_label"
        
        return label
    }

    private func configureCollectionView() -> UICollectionView {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = .zero

        let collectionView = BUCollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        
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
        return CGSize(width: collectionView.frame.width * 0.7, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
}

// MARK: - EmptyDataSetSource

extension ProfileAhievementsView: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "ui_empty_archivementes_list".localized,
                                  attributes: [.foregroundColor : Colors.textStateColor,
                                               .font: UIFont.avenirRoman(16)])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        return AssetsHelper.shared.image(.emptyTasksListIcon)?.resizedImage(targetSize: .init(width: 50,
                                                                                              height: 50))
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        
        return Colors.textStateColor
    }
}
