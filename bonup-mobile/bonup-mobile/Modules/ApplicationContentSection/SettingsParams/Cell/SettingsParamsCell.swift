//
//  SettingsParamsCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class SettingsParamsCell: UITableViewCell {

    // MARK: - Static

    static let reuseId = String(describing: SettingsTableViewCell.self)
    static let cellHeight: CGFloat = 60.0

    // MARK: - UI variables

    private var titleLabel: UILabel!
    private var selectedImageView: UIImageView!

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupSubviews()
        self.setupAppearance()
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    func configure(with viewModel: SettingsParamsCellViewModel) {

        self.titleLabel.text = viewModel.title
        self.selectedImageView.image = viewModel.isSelected ? AssetsHelper.shared.image(.activeCheckBox) : nil
    }

    // MARK: - Setup

    private func setupSubviews() {

        self.titleLabel = self.configureTitleLabel()
        self.selectedImageView = self.configureSelectedImageView()

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.selectedImageView)

        self.titleLabel.snp.makeConstraints { make in

            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15.0)
            make.trailing.equalTo(self.selectedImageView.snp.leading).offset(-10.0)
        }

        self.selectedImageView.snp.makeConstraints { make in

            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10.0)
            make.size.equalTo(40.0)
        }
    }

    private func setupAppearance() {

        self.backgroundColor = .clear
    }

    // MARK: - Configure

    private func configureTitleLabel() -> UILabel {

        let label = UILabel()

        label.theme_textColor = Colors.defaultTextColor
        label.font = UIFont.avenirRoman(20.0)

        return label
    }

    private func configureSelectedImageView() -> UIImageView {

        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.theme_tintColor = Colors.defaultTextColor

        return imageView
    }
}
