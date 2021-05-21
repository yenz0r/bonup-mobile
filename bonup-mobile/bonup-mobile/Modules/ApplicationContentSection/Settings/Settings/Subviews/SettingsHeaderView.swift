//
//  SettingsHeaderView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class SettingsHeaderView: UIView {

    // MARK: - Public variables

    var avatarImage: UIImage? {

        didSet {

            self.avatarImageView.image = self.avatarImage
        }
    }

    var name: String? {
        didSet {
            self.nameLabel.text = self.name
        }
    }

    var email: String? {
        didSet {
            self.emailLabel.text = self.email
        }
    }

    var onAvatarTap: (() -> ())?
    
    var avatarImageView: UIImageView!

    // MARK: - Private variables

    private var infoContainer: UIView!
    private var nameLabel: UILabel!
    private var emailLabel: UILabel!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup subviews

    private func setupSubviews() {

        self.avatarImageView = {
            let imageView = UIImageView()

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.theme_tintColor = Colors.tabBarIconColor

            let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
            imageView.addGestureRecognizer(gesture)
            imageView.isUserInteractionEnabled = true

            return imageView
        }()

        self.nameLabel = {
            let label = UILabel()

            label.font = UIFont.avenirHeavy(28.0)
            label.theme_textColor = Colors.defaultTextColor
            label.textAlignment = .left
            label.contentScaleFactor = 0.4

            return label
        }()

        self.emailLabel = {
            let label = UILabel()

            label.font = UIFont.avenirRoman(18.0)
            label.theme_textColor = Colors.defaultTextColor
            label.textAlignment = .left
            label.contentScaleFactor = 0.4

            return label
        }()

        self.addSubview(self.avatarImageView)
        self.avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20.0)
            make.size.equalTo(60.0)
            make.centerY.equalToSuperview()
        }

        let dynamicContainer = UIView()
        self.addSubview(dynamicContainer)
        dynamicContainer.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).offset(20.0)
            make.top.trailing.bottom.equalToSuperview()
        }

        dynamicContainer.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(10.0)
        }

        dynamicContainer.addSubview(self.emailLabel)
        self.emailLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(10.0)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10.0)
        }

    }

    // MARK: - Selectors

    @objc private func avatarTapped() {

        self.onAvatarTap?()
    }

}
