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

        self.categoryTitleLabel.loc_text = model.title
        self.categoryIconView.image = model.category.icon
        
        var color: UIColor
        if model.isActive {
            
            color = UIColor.systemGreen.withAlphaComponent(0.5)
        }
        else {
            
            color = UIColor.systemRed.withAlphaComponent(0.5)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.contentView.backgroundColor = color
        }
    }

    // MARK: - State variables

    private var isFirstLayout = true

    // MARK: - UI variables

    private var categoryTitleLabel: BULabel!
    private var categoryIconView: UIImageView!

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

            self.isFirstLayout = false
        }
    }

    // MARK: - Setup

    private func setupAppearance() {

        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)

        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }

    private func setupSubviews() {

        self.categoryTitleLabel = configureTitleLabel()
        self.categoryIconView = self.configureCategoryIconView()

        self.contentView.addSubview(self.categoryTitleLabel)
        self.contentView.addSubview(self.categoryIconView)

        self.categoryIconView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(self.categoryIconView.snp.height)
        }
        
        self.categoryTitleLabel.snp.makeConstraints { make in
            
            make.leading.equalTo(self.categoryIconView.snp.trailing).offset(10)
            make.trailing.equalTo(self.contentView).inset(20)
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
        
        label.textColor = .white

        return label
    }
    
    private func configureCategoryIconView() -> UIImageView {
        
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        
        return iv
    }
}
