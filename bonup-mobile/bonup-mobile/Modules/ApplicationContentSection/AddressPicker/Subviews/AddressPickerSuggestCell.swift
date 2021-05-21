//
//  AddressPickerSuggestCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class AddressPickerSuggestCell: UITableViewCell {
    
    // MARK: - Static
    
    static let reuseId = NSStringFromClass(AddressPickerSuggestCell.self)
    
    // MARK: - UI
    
    private var container: UIView!
    private var titleLabel: UILabel!
    
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
    
    func setupTitle(_ title: String) {
        
        self.titleLabel.text = title
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.container.setupSectionStyle()
    }
    
    private func setupSubviews() {
        
        self.container = self.configureContainer()
        self.titleLabel = self.configureTitleLabel()
        
        self.contentView.addSubview(self.container)
        self.container.addSubview(self.titleLabel)
        
        self.container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Configure
    
    private func configureContainer() -> UIView {
        
        let container = UIView()
        
        container.backgroundColor = .clear
        
        return container
    }
    
    private func configureTitleLabel() -> UILabel {
        
        let label = UILabel()
        
        label.theme_textColor = Colors.defaultTextColor
        label.font = .avenirRoman(14)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }
}
