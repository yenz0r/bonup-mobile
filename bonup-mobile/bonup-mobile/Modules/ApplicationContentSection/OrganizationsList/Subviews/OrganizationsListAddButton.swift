//
//  OrganizationsListAddButton.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class OrganizationsListAddButton: UIView {

    // MARK: - Initiazation

    init(_ onTap: (() -> ())?) {

        super.init(frame: .zero)

        self.onTap = onTap

        self.setupSubviews()
        self.setupAppearance()
        self.setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Action variables

    private var onTap: (() -> ())?

    // MARK: - UI variables

    private var icon: UIImageView!
    private var titleLabel: BULabel!
    private var bottomSeparator: UIView!

    // MARK: - Setup

    private func setupSubviews() {

        self.titleLabel = self.configureTitleLabel()
        self.icon = self.configureIcon()
        self.bottomSeparator = self.configureSeparator()

        self.addSubview(self.icon)
        self.addSubview(self.titleLabel)
        self.addSubview(self.bottomSeparator)

        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        self.icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.icon.snp.trailing).offset(20)
        }

        self.bottomSeparator.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(1)
        }
    }

    private func setupAppearance() {

        self.backgroundColor = .clear
    }

    private func setupActions() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(addTapped))
        self.addGestureRecognizer(gesture)
    }

    // MARK: - Configure

    private func configureTitleLabel() -> BULabel {

        let label = BULabel()

        label.nonlocalizedTitle = "ui_add_new_company"
        label.textAlignment = .left
        label.font = UIFont.avenirRoman(20)
        label.theme_textColor = Colors.defaultTextColor
        label.isUserInteractionEnabled = false

        return label
    }

    private func configureIcon() -> UIImageView {

        let imageView = UIImageView()

        imageView.theme_tintColor = Colors.navBarIconColor
        imageView.image = AssetsHelper.shared.image(.addIcon)
        imageView.isUserInteractionEnabled = false

        return imageView
    }

    private func configureSeparator() -> UIView {

        let separator = UIView()

        separator.theme_backgroundColor = Colors.grayTextColor

        return separator
    }

    // MARK: - Selectors

    @objc private func addTapped() {

        self.onTap?()
    }
}
