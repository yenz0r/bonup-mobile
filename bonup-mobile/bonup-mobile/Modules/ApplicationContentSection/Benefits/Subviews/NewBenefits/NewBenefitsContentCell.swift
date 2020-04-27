//
//  NewBenefitsContentCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class NewBenefitsContentCell: UICollectionViewCell {

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
            guard let coastStr = self.coastText, let coast = Int(coastStr) else {
                self.saveButton.setAttributedTitle(nil, for: .normal)
                return
            }

            var color = UIColor.black
            switch coast {
            case (0..<100):
                color = .yellow
            case (200..<300):
                color = .orange
            case (300..<350):
                color = .red
            default:
                break
            }

            self.saveButton.setAttributedTitle(
                NSAttributedString.with(
                    title: "-\(coastStr)",
                    textColor: color,
                    font: UIFont.avenirRoman(20.0)
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

        self.saveButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(40.0)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(10.0)
            make.trailing.equalTo(self.saveButton.snp.leading).offset(-5.0)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(10.0)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5.0)
            make.trailing.equalTo(self.saveButton.snp.trailing).offset(-5.0)
        }

        self.aliveTimeLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(10.0)
        }
    }

    // MARK: - Configure

    private func configureSaveButton() -> UIButton {
        let button = UIButton(type: .system)

        button.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        return button
    }

    private func configureInfoLabel(for type: InfoType) -> UILabel {
        let label = UILabel()

        label.textAlignment = .left

        switch type {
        case .description:
            label.font = UIFont.avenirRoman(15.0)
            label.textColor = UIColor.systemBlue.withAlphaComponent(0.5)
        case .title:
            label.font = UIFont.avenirHeavy(20.0)
            label.textColor = UIColor.purpleLite.withAlphaComponent(0.5)
        case .alive:
            label.font = UIFont.avenirHeavy(10.0)
            label.textColor = .white
        }

        return label
    }

    // MARK: - Selectors

    @objc private func saveButtonTapped() {
        self.onSaveTap?()
    }

    // MARK: - Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleText = nil
        self.descriptionText = nil
        self.coastText = nil
        self.aliveTimeText = nil
        self.onSaveTap = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.purpleLite.withAlphaComponent(0.3).cgColor
    }
}
