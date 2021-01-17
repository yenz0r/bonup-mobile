//
//  CompanySearchCategoryCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class CompaniesSearchCategoryCell: UICollectionViewCell {

    // MARK: - Static

    static let reuseId = NSStringFromClass(CompaniesSearchCategoryCell.self)
    static let cellHeight: CGFloat = 50

    // MARK: - Public

    func configure(with model: CompaniesSearchCategoryModel) {

        self.titleLabel.text = model.title
        self.titleLabel.textColor = model.isActive ? .green : .red
    }

    // MARK: - State variables

    private var isFirstLayout = true

    // MARK: - UI variables

    private var titleLabel: UILabel!

    // MARK: - Initialization

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.setupSubviews()
        self.setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {

        super.layoutSubviews()

        if (self.isFirstLayout) {

            self.contentView.setupBlur()
            self.isFirstLayout = false
        }
    }

    // MARK: - Setup

    private func setupAppearance() {

        self.backgroundColor = .clear

        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }

    private func setupSubviews() {

        self.titleLabel = configureTitleLabel()

        self.contentView.addSubview(self.titleLabel)

        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.contentView).inset(20)
            make.top.bottom.equalTo(self.contentView)
        }

        self.contentView.snp.makeConstraints { make in
            make.height.equalTo(CompaniesSearchCategoryCell.cellHeight)
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configure

    private func configureTitleLabel() -> UILabel {

        let label = UILabel()

        return label
    }
}
