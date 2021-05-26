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
        
        self.contentView.layer.cornerRadius = 25
        self.contentView.layer.masksToBounds = true
        
        self.setupSectionStyle()
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

        label.font = UIFont.avenirHeavy(20.0)
        label.theme_textColor = Colors.defaultTextColor
        label.textAlignment = .left
        label.numberOfLines = 0

        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10.0)
            make.leading.equalTo(self.statusView.snp.trailing).offset(10.0)
        }

        return label
    }

    private func configureDescriptionLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.avenirRoman(15.0)
        label.theme_textColor = Colors.defaultTextColorWithAlpha
        label.textAlignment = .left
        label.numberOfLines = 0

        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10.0)
            make.leading.equalTo(self.statusView.snp.trailing).offset(10.0)
            make.bottom.equalToSuperview().inset(10.0)
            make.height.greaterThanOrEqualTo(20.0)
        }

        return label
    }

    private func configureDateOfEndLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.avenirHeavy(12.0)
        label.theme_textColor = Colors.defaultTextColorWithAlpha
        label.textAlignment = .right

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

        label.font = UIFont.avenirHeavy(12.0)
        label.textAlignment = .right
        label.textColor = UIColor.systemGreen.withAlphaComponent(0.8)

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
}
