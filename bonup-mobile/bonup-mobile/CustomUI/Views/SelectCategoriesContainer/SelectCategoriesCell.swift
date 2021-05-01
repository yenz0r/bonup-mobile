//
//  SelectCategoriesCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class SelectCategoriesCell: UICollectionViewCell {

    // MARK: - Static

    static let reuseId = NSStringFromClass(SelectCategoriesCell.self)
    static let cellHeight: CGFloat = 50

    // MARK: - Public

    func configure(with model: SelectCategoriesCellModel) {

        self.categoryTitleLabel.nonlocalizedTitle = model.title
        self.categoryTitleLabel.textColor = model.isActive ? .green : .red
    }

    // MARK: - State variables

    private var isFirstLayout = true

    // MARK: - UI variables

    private var categoryTitleLabel: BULabel!

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

        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)

        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }

    private func setupSubviews() {

        self.categoryTitleLabel = configureTitleLabel()

        self.contentView.addSubview(self.categoryTitleLabel)

        self.categoryTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.contentView).inset(20)
            make.top.bottom.equalTo(self.contentView)
        }

        self.contentView.snp.makeConstraints { make in
            make.height.equalTo(SelectCategoriesCell.cellHeight)
            make.top.bottom.equalToSuperview().priority(999)
            make.leading.trailing.equalToSuperview()
        }
    }

    // MARK: - Configure

    private func configureTitleLabel() -> BULabel {

        let label = BULabel()

        return label
    }
}
