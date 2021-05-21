//
//  NewBenefitsContentCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class NewBenefitsContentCell: BenefitsContentCell {

    enum InfoType {
        case title, description, alive
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

    var aliveTimeText: String? {
        didSet {
            self.aliveTimeLabel.text = self.aliveTimeText
        }
    }

    var coastText: String? {
        didSet {

            self.saveButton.setAttributedTitle(
                NSAttributedString.with(
                    title: "-\(coastText ?? "0")",
                    textColor: .systemRed,
                    font: UIFont.avenirRoman(18.0)
                ),
                for: .normal
            )
        }
    }

    var onSaveTap: (() -> Void)?

    // MARK: - Private UI variables

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var aliveTimeLabel: UILabel!
    private var saveButton: UIButton!

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
        self.titleLabel = self.configureInfoLabel(for: .title)
        self.descriptionLabel = self.configureInfoLabel(for: .description)
        self.aliveTimeLabel = self.configureInfoLabel(for: .alive)
        self.saveButton = self.configureSaveButton()

        [self.titleLabel,
         self.descriptionLabel,
         self.saveButton,
         self.aliveTimeLabel].forEach { self.contentView.addSubview($0) }

        self.aliveTimeLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10.0)
            make.trailing.equalTo(self.saveButton.snp.leading).offset(-5)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(70.0)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.aliveTimeLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(10.0)
            make.trailing.equalTo(self.saveButton.snp.leading).offset(-5.0)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(10.0)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5.0)
            make.trailing.equalTo(self.saveButton.snp.trailing).offset(-5.0)
        }
    }

    // MARK: - Configure

    private func configureSaveButton() -> UIButton {
        let button = UIButton(type: .system)

        button.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        return button
    }

    private func configureInfoLabel(for type: InfoType) -> UILabel {
        let label = UILabel()

        label.textAlignment = .left

        switch type {
        case .description:
            label.font = UIFont.avenirRoman(15.0)
            label.theme_textColor = Colors.defaultTextColorWithAlpha
            
        case .title:
            label.font = UIFont.avenirHeavy(20.0)
            label.theme_textColor = Colors.defaultTextColor
            
        case .alive:
            label.font = UIFont.avenirHeavy(10.0)
            label.theme_textColor = Colors.defaultTextColorWithAlpha
        }

        return label
    }

    // MARK: - Selectors

    @objc private func saveButtonTapped() {
        
        self.onSaveTap?()
    }
}
