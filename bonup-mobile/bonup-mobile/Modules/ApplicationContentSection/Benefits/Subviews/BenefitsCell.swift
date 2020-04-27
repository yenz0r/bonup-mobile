//
//  BenefitsCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

class BenefitsCell: UICollectionViewCell {

    // MARK: - UI variables

    var collectionView: UICollectionView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup subviews

    private func setupSubviews() {
        self.collectionView = self.configureCollectionView()

        self.contentView.addSubview(self.collectionView)

        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10.0)
        }
    }

    // MARK: - Configure

    private func configureCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = 10.0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.backgroundColor = .white

        return collectionView
    }
}
