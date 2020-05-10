//
//  UsedBenefitsContentCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class UsedBenefitsContentCell: BenefitsContentCell {

    enum LabelType {
        case title, description, dateOfUse
    }

    // MARK: - Static variables

    static let reuseId = String(describing: type(of: self))

    // MARK: - Public variables

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

    var dateOfUseText: String? {
        didSet {
            guard let date = self.dateOfUseText else {
                self.dateOfUseLabel.text = nil
                return
            }

            let titleText = "ui_date_of_use".localized
            self.dateOfUseLabel.text = "\(titleText) \(date)"
        }
    }

    // MARK: - Private UI variables

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var dateOfUseLabel: UILabel!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func prepareForReuse() {

        self.titleText = nil
        self.descriptionText = nil
        self.dateOfUseText = nil
    }

    // MARK: - Setup subviews

    private func setupSubviews() {

        self.titleLabel = self.configureLabel(for: .title)
        self.descriptionLabel = self.configureLabel(for: .description)
        self.dateOfUseLabel = self.configureLabel(for: .dateOfUse)

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.dateOfUseLabel)

        self.titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8.0)
            make.leading.equalToSuperview().inset(15.0)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10.0)
            make.leading.trailing.equalToSuperview().inset(8.0)
        }

        self.dateOfUseLabel.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(8.0)
            make.trailing.equalToSuperview().offset(-8.0)
            make.bottom.equalToSuperview().offset(-8.0)
        }
    }

    // MARK: - Configure

    private func configureLabel(for type: LabelType) -> UILabel {
        let label = UILabel()

        switch type {
        case .title:
            label.font = UIFont.avenirHeavy(20.0)
            label.textColor = UIColor.purpleLite.withAlphaComponent(0.8)
            label.textAlignment = .left
        case .description:
            label.font = UIFont.avenirRoman(15.0)
            label.textColor = UIColor.purpleLite.withAlphaComponent(0.3)
            label.textAlignment = .left
        case .dateOfUse:
            label.font = UIFont.avenirHeavy(12.0)
            label.textAlignment = .right
            label.textColor = UIColor.red.withAlphaComponent(0.3)
        }

        return label
    }
}
