//
//  BenefitsContentCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 10.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

class BenefitsContentCell: UICollectionViewCell {

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.snp.makeConstraints { make in
            make.width.equalTo(frame.size.width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return self.contentView .systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }

    // MARK: - Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.purpleLite.withAlphaComponent(0.3).cgColor
    }
    
}
