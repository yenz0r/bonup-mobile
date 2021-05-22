//
//  AddCompanyUsesCountContainer.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 23.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class AddCompanyUsesCountContainer: UIView {
    
    // MARK: - Public variables
    
    var countText: String? {
        
        didSet {
            
            self.countLabel.text = countText
        }
    }
    
    // MARK: - UI variables
    
    private var titleLabel: BULabel!
    private var countLabel: BULabel!
    
    // MARK: - Init
    
    init() {
        
        super.init(frame: .zero)
        
        self.setupSubviews()
        self.setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.setupBlur()
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.backgroundColor = .clear
        self.layer.maskedCorners = [.layerMinXMaxYCorner]
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    private func setupSubviews() {
        
        self.titleLabel = self.configureLabel()
        self.titleLabel.loc_text = "ui_used_label"
        self.countLabel = self.configureLabel()
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.countLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
        }
        
        self.countLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(10)
        }
    }
    
    // MARK: - Configure
    
    private func configureLabel() -> BULabel {
        
        let label = BULabel()
        
        label.font = .avenirHeavy(14)
        label.theme_textColor = Colors.defaultTextColorWithAlpha
        label.textAlignment = .center
        
        return label
    }
}
