//
//  EmptyContainer.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 14.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class BUEmptyContainer: UIView {

    // MARK: - UI variables

    private var imageView: UIImageView!
    private var descriptionLabel: UILabel!

    // MARK: - Data variables

    var descriptionText: String? {

        didSet {

            self.descriptionLabel.text = self.descriptionText
        }
    }

    var image: UIImage? {

        didSet {

            self.imageView.image = self.image
        }
    }

    // MARK: - Initialization

    init() {

        super.init(frame: .zero)

        self.setupSubviews()
        self.setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupSubviews() {

        self.descriptionLabel = self.configureDescriptionLabel()
        self.imageView = self.configureImageView()

        self.addSubview(self.imageView)
        self.addSubview(self.descriptionLabel)

        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.width.equalTo(self.imageView.snp.height)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(10.0)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func setupAppearance() {

        self.backgroundColor = .clear
        self.imageView.theme_tintColor = Colors.settingsIconsColor
        self.descriptionLabel.theme_textColor = Colors.grayTextColor
    }

    // MARK: - Configure

    private func configureImageView() -> UIImageView {

        let iv = UIImageView()

        iv.contentMode = .scaleAspectFit

        return iv
    }

    private func configureDescriptionLabel() -> UILabel {

        let label = UILabel()
        
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.avenirRoman(20.0)

        return label
    }
}
