//
//  FinishedTasksCollectionViewCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class FinishedTasksCollectionViewCell: UICollectionViewCell {

    // MARK: - Public variables

    static let reuseId = String(describing: type(of: self))

    var titleText: String? {
        didSet {
            self.titleLabel.text = self.titleText
        }
    }

    var descriptionText: String? {
        didSet {
            self.descriptionLabel.text = self.descriptionText
        }
    }

    var dateOfEndText: String? {
        didSet {
            self.dateOfEndLabel.text = self.dateOfEndText
        }
    }

    var benefitText: String? {
        didSet {
            self.benefitLabel.text = self.benefitText
        }
    }

    var isDone: Bool? {
        didSet {
            let status = self.isDone ?? false
            self.statusView.backgroundColor = status ? .green : .red
        }
    }

    // MARK: - Private variables

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var dateOfEndLabel: UILabel!
    private var statusView: UIView!
    private var benefitLabel: UILabel!
    private var separatorView: UIView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.statusView = self.configureStatusView()
        self.titleLabel = self.configureTitleLabel()
        self.descriptionLabel = self.configureDescriptionLabel()
        self.dateOfEndLabel = self.configureDateOfEndLabel()
        self.benefitLabel = self.configureBenefitLabel()
        self.separatorView = self.configureSeparatorView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    private func configureStatusView() -> UIView {
        let view = UIView()

        self.contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(20.0)
        }

        return view
    }

    private func configureTitleLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.avenirRoman(15.0)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.black

        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10.0)
            make.leading.equalTo(self.statusView.snp.trailing).offset(10.0)
        }

        return label
    }

    private func configureDescriptionLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.avenirRoman(12.0)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.black.withAlphaComponent(0.5)

        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10.0)
            make.leading.equalTo(self.statusView.snp.trailing).offset(15.0)
            make.bottom.equalToSuperview().inset(10.0)
            make.height.greaterThanOrEqualTo(20.0)
        }

        return label
    }

    private func configureDateOfEndLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.avenirRoman(12.0)
        label.textAlignment = .right
        label.textColor = UIColor.red.withAlphaComponent(0.5)

        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10.0)
            make.centerY.equalTo(self.titleLabel)
            make.width.equalTo(70.0)
        }

        return label
    }

    private func configureBenefitLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.avenirRoman(12.0)
        label.textAlignment = .right
        label.textColor = UIColor.green.withAlphaComponent(0.5)

        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10.0)
            make.centerY.equalTo(self.descriptionLabel)
        }

        return label
    }

    private func configureSeparatorView() -> UIView {
        let view = UIView()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)

        self.contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.trailing.equalTo(self.dateOfEndLabel.snp.leading).offset(-10.0)
            make.top.bottom.equalToSuperview().inset(15.0)
            make.width.equalTo(1.0)
            make.leading.equalTo(self.descriptionLabel.snp.trailing).offset(10.0)
        }

        return view
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor.purpleLite.withAlphaComponent(0.5).cgColor
        self.contentView.layer.borderWidth = 1.0
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleText = nil
        self.descriptionText = nil
        self.dateOfEndText = nil
        self.benefitText = nil
        self.isDone = nil
    }

}
