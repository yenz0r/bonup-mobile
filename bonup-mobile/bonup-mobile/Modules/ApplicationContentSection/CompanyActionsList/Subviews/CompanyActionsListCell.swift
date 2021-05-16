//
//  CompanyActionsListCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class CompanyActionsListCell: UITableViewCell {
    
    enum LabelType {
        
        case title, description, dateInfo
    }
    
    // MARK: - Static
    
    static let reuseId = NSStringFromClass(CompanyActionsListCell.self)
    
    // MARK: - UI variables
    
    private var container: UIView!
    private var titleLabel: BULabel!
    private var descriptionLabel: BULabel!
    private var dateLabel: BULabel!
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupSubviews()
        self.setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func setup(title: String, descriptionInfo: String, dateInfo: String) {
        
        self.titleLabel.text = title
        self.descriptionLabel.text = descriptionInfo
        self.dateLabel.text = dateInfo
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
     
        self.container = UIView()
        self.titleLabel = self.configureLabel(of: .title)
        self.descriptionLabel = self.configureLabel(of: .description)
        self.dateLabel = self.configureLabel(of: .dateInfo)
        
        self.contentView.addSubview(self.container)
        
        self.container.snp.makeConstraints { make in
            
            make.edges.equalToSuperview().inset(10)
        }
        
        self.container.addSubview(self.titleLabel)
        self.container.addSubview(self.descriptionLabel)
        self.container.addSubview(self.dateLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            
            make.leading.trailing.top.equalToSuperview().inset(10)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            
            make.leading.trailing.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            
            make.trailing.leading.equalTo(self.descriptionLabel)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(10)
        }
    }
    
    private func setupAppearance() {
        
        self.setupSectionStyle()
    }
    
    // MARK: - Configure
    
    private func configureLabel(of type: LabelType) -> BULabel {
        
        let label = BULabel()
        
        label.numberOfLines = 0
        
        switch type {
        
        case .title:
            label.font = .avenirHeavy(20)
            label.theme_textColor = Colors.defaultTextColor
            label.textAlignment = .left
            
        case .description:
            label.font = .avenirRoman(16)
            label.theme_textColor = Colors.defaultTextColorWithAlpha
            label.textAlignment = .left
            
        case .dateInfo:
            label.font = .avenirHeavy(13)
            label.theme_textColor = Colors.defaultTextColor
            label.textAlignment = .right
            
        }
        
        return label
    }
}
