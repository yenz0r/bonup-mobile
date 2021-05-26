//
//  BenefitsContentCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 10.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

class BenefitsContentCell: UICollectionViewCell {

    // MARK: - Public
    
    var width: CGFloat = 0 {
        
        didSet {
            
            self.widthConstraint.isActive = false
            self.widthConstraint.constant = width - 20
            self.widthConstraint.isActive = true
        }
    }
    
    // MARK: - Private
    
    private var widthConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        
        super.init(frame: frame)

        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.widthConstraint = self.contentView.widthAnchor.constraint(equalToConstant: frame.width)
        
        NSLayoutConstraint.activate([
            self.widthConstraint,
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func layoutSubviews() {
        
        self.setupSectionStyle()
        self.contentView.layer.cornerRadius = 25
        self.contentView.layer.masksToBounds = true
    }
    
}
