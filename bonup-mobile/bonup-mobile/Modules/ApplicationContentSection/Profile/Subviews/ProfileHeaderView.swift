//
//  ProfileHeaderView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 23.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDataSource: AnyObject {
    func iconForProfileHeaderView(_ profileHeaderView: ProfileHeaderView) -> UIImage?
    func urlForIconInProfileHeaderView(_ profileHeaderView: ProfileHeaderView) -> URL?
    func profileHeaderView(_ profileHeaderView: ProfileHeaderView,
                           userInfoFor type: ProfileHeaderView.UserInfoType) -> String?
}

final class ProfileHeaderView: UIView {

    enum UserInfoType {
        case name, email, organization
    }

    enum UserInfoPosition {
        case left, center, right
    }

    // MARK: - Public variables

    var dataSource: ProfileHeaderViewDataSource!

    // MARK: - Private variables

    private var nameValueLabel: UILabel!
    private var emailValueLabel: UILabel!
    private var organizationValueLabel: UILabel!
    private var iconImageView: BULoadImageView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureAppearace()
        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lyfe cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.width / 2
        self.iconImageView.layer.masksToBounds = true
    }

    // MARK: - Public functions

    func reloadData() {
        self.nameValueLabel.text = self.dataSource.profileHeaderView(self, userInfoFor: .name) ?? "-"
        self.emailValueLabel.text = self.dataSource.profileHeaderView(self, userInfoFor: .email) ?? "-"
        self.organizationValueLabel.text = self.dataSource.profileHeaderView(self,
                                                                             userInfoFor:  .organization) ?? "-"
        
        guard let url = self.dataSource.urlForIconInProfileHeaderView(self) else {
            
            iconImageView.image = AssetsHelper.shared.image(.usernameIcon)
            return
        }
        
        self.iconImageView.loadFrom(url: url)
    }

    // MARK: - Setup subviews

    private func setupSubviews() {
        self.snp.makeConstraints { make in
            make.height.equalTo(100.0)
        }

        self.iconImageView = self.configureImageView()

        let nameTitleLabel = self.configureLabel(with: "ui_my_name")
        self.nameValueLabel = self.configureLabel(with: nil)
        let nameContainer = self.configureTextContainer(
            title: nameTitleLabel,
            value: self.nameValueLabel)

        let emailTitleLabel = self.configureLabel(with: "ui_my_email")
        self.emailValueLabel = self.configureLabel(with: nil)
        let emailContainer = self.configureTextContainer(
            title: emailTitleLabel,
            value: self.emailValueLabel)

        let organizationTitleLabel = self.configureLabel(with: "ui_my_organization")
        self.organizationValueLabel = self.configureLabel(with: nil)
        let organizationContainer = self.configureTextContainer(
            title: organizationTitleLabel,
            value: self.organizationValueLabel)

        let userInfoStackView = self.configureStackView()

        [nameContainer,
        emailContainer,
        organizationContainer].forEach { userInfoStackView.addArrangedSubview($0) }

        self.addSubview(self.iconImageView)
        self.addSubview(userInfoStackView)

        self.iconImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10.0)
            make.height.equalTo(self.iconImageView.snp.width)
        }

        userInfoStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(10.0)
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(8.0)
        }

        userInfoStackView.clipsToBounds = true
    }

    // MARK: - Configure

    private func configureAppearace() {
        
        self.setupSectionStyle()
    }

    private func configureTextContainer(title: UILabel,
                                        value: UILabel) -> UIView {
        let container = UIView()

        let staticContainer = UIView()
        staticContainer.addSubview(title)
        staticContainer.addSubview(value)

        title.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }

        value.snp.makeConstraints { make in
            make.leading.equalTo(title.snp.trailing).offset(10.0)
            make.top.bottom.trailing.equalToSuperview()
        }

        container.addSubview(staticContainer)
        staticContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }

        staticContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
        }

        return container
    }

    private func configureLabel(with text: String?) -> UILabel {
        let label = BULabel()

        label.textAlignment = .left
        label.font = UIFont.avenirRoman(15.0)
        label.theme_textColor = Colors.defaultTextColor
        label.loc_text = text
        label.numberOfLines = 0

        return label
    }

    private func configureStackView() -> UIStackView {
        let stack = UIStackView()

        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 7.0

        return stack
    }

    private func configureImageView() -> BULoadImageView {
        
        let imageView = BULoadImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.theme_tintColor = Colors.defaultTextColor

        return imageView
    }
}
