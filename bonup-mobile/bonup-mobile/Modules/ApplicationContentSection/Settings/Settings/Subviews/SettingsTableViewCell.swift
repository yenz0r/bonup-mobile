//
//  SettingsTableViewCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {

    // MARK: - Public variables

    static let reuseId = String(describing: SettingsTableViewCell.self)

    var iconImage: UIImage? {
        didSet {
            self.iconImageView.image = self.iconImage
        }
    }

    var title: String? {
        didSet {
            self.titleLabel.loc_text = self.title
        }
    }

    var isLogout: Bool? {
        didSet {
            let isLogout = self.isLogout ?? false
            self.titleLabel.theme_textColor = isLogout ? Colors.redColor : Colors.defaultTextColor
        }
    }

    // MARK: - Private variables

    private var iconImageView: UIImageView!
    private var titleLabel: BULabel!

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupSubviews()
        self.setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupAppearance() {

        self.backgroundColor = .clear
    }

    private func setupSubviews() {

        self.iconImageView = {
            let imageView = UIImageView()

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.theme_tintColor = Colors.settingsIconsColor

            return imageView
        }()

        self.titleLabel = {
            let label = BULabel()

            label.font = UIFont.avenirRoman(20.0)
            label.theme_textColor = Colors.defaultTextColor
            label.textAlignment = .left

            return label
        }()

        self.contentView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15.0)
            make.size.equalTo(30.0)
            make.centerY.equalToSuperview()
        }

        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(20.0)
            make.top.trailing.bottom.equalToSuperview()
        }

    }

    // MARK: - Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.height / 2
    }
}
