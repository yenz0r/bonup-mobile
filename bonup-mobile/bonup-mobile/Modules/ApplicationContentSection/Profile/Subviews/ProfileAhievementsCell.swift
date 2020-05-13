//
//  ProfileAhievementsCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 23.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class ProfileAhievementsCell: UICollectionViewCell {

    // MARK: - Public variables

    static let reuseId = String(describing: type(of: self))

    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }

    var descriptionText: String? {
        didSet {
            self.descriptionLabel.text = self.descriptionText
        }
    }

    // MARK: - Private variables

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureAppearance()
        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        self.title = nil
        self.descriptionText = nil
    }

    // MARK: - Setup subviews

    private func setupSubviews() {
        self.titleLabel = self.configureTitleLabel()
        self.descriptionLabel = self.configureDescriptionLabel()
        let descriptionContainer = self.configureDescriptionContainer(with: self.descriptionLabel)

        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(15.0)
        }

        self.contentView.addSubview(descriptionContainer)
        descriptionContainer.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10.0)
        }
    }

    // MARK: - Configure

    private func configureAppearance() {
        self.layer.cornerRadius = 15.0
        self.layer.borderColor = UIColor.purpleLite.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }

    private func configureTitleLabel() -> UILabel {
        let label = UILabel()

        label.textAlignment = .center
        label.font = UIFont.avenirHeavy(25.0)
        label.textColor = UIColor.orange.withAlphaComponent(0.5)
        label.minimumScaleFactor = 0.4
        label.adjustsFontSizeToFitWidth = true

        return label
    }

    private func configureDescriptionLabel() -> UILabel {
        let label = UILabel()

        label.textAlignment = .center
        label.font = UIFont.avenirHeavy(15.0)
        label.textColor = UIColor.blue.withAlphaComponent(0.4)
        label.numberOfLines = 0

        return label
    }

    private func configureDescriptionContainer(with label: UILabel) -> UIView {
        let container = UIView()

        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.purpleLite.withAlphaComponent(0.3)
        container.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1.0)
        }

        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return container
    }
}
