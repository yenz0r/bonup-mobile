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
            
            make.width.equalTo(frame.size.width).priority(999)
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func layoutSubviews() {
        
        self.setupSectionStyle()
    }
    
}
