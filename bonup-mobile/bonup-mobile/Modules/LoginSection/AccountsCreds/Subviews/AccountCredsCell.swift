//
//  AccountCredsCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 8.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class AccountCredsCell: UITableViewCell {
    
    enum LabelType {
        
        case name, email
    }
    
    // MARK: - Static
    
    static let reuseId = NSStringFromClass(AccountCredsCell.self)
    
    // MARK: - UI variables
    
    private var nameLabel: UILabel!
    private var emailLabel: UILabel!
    private var containerView: UIView!
    
    // MARK: - State variables
    
    private var isFirstLayout = true
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupSubviews()
        self.setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public functions
    
    func configure(with creds: AuthCredRealmObject) {
        
        self.nameLabel.text = "ui_name_label".localized + creds.name
        self.emailLabel.text = "ui_email_label".localized + creds.email
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        
        self.containerView = self.configureContainerView()
        self.nameLabel = self.configureLabel(for: .name)
        self.emailLabel = self.configureLabel(for: .email)
        
        self.contentView.addSubview(self.containerView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.emailLabel)
        
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            
            make.top.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        self.emailLabel.snp.makeConstraints { make in
            
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(15)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
        }
    }
    
    private func setupAppearance() {
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.isFirstLayout {
            
            self.isFirstLayout.toggle()
            
            self.containerView.layer.cornerRadius = 10
            self.containerView.layer.masksToBounds = true
        }
    }
    
    // MARK: - Configure
    
    private func configureContainerView() -> UIView {
        
        let container = UIView()
        
        container.backgroundColor = .black.withAlphaComponent(0.15)
        
        return container
    }
    
    private func configureLabel(for type: LabelType) -> UILabel {
    
        let label = UILabel()
        
        label.font = type == .name ? .avenirHeavy(20) : .avenirRoman(17)
        label.textColor = type == .name ? .white : .white.withAlphaComponent(0.8)
        label.textAlignment = .left
        
        return label
    }
}
