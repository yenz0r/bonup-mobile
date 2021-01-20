//
//  CompanyPacketCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class CompanyPacketCell: UITableViewCell {

    // MARK: - Static

    static let reuseId = NSStringFromClass(CompanyPacketCell.self)

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupSubviews()
        self.setupAppearance()
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public variables

    var isPacketSelected: Bool = false {

        didSet {

            UIView.transition(with: self.iconImageView,
                              duration: 0.3,
                              options: .transitionFlipFromLeft,
                              animations: {

                                self.iconImageView.image = self.isPacketSelected ? AssetsHelper.shared.image(.activeCheckBox) : self.packetType.icon
                              },
                              completion: nil)
        }
    }

    var packetType: CompanyPacketType = .junior {

        didSet {

            self.titleLabel.nonlocalizedTitle = self.packetType.title
            self.titleLabel.textColor = self.packetType.color

            if let tasks = self.packetType.tasksCount {
                self.tasksContainer.value = "\(tasks)"
            } else {
                self.tasksContainer.value = "-"
            }
            self.tasksContainer.valueColor = self.packetType.color

            if let benefits = self.packetType.benefitsCount {
                self.benefitsContainer.value = "\(benefits)"
            } else {
                self.benefitsContainer.value = "-"
            }
            self.benefitsContainer.valueColor = self.packetType.color

            if let price = self.packetType.price {
                self.priceContainer.value = "\(price)$"
            } else {
                self.priceContainer.value = "-"
            }
            self.priceContainer.valueColor = self.packetType.color
        }
    }

    // MARK: - UI variables

    private var titleLabel: BULabel!
    private var priceContainer: TitleValueContainer!
    private var tasksContainer: TitleValueContainer!
    private var benefitsContainer: TitleValueContainer!
    private var iconImageView: UIImageView!

    // MARK: - Setup

    private func setupSubviews() {

        self.titleLabel = self.configureTitleLabel()
        self.iconImageView = self.configureIconImageView()
        self.tasksContainer = TitleValueContainer(type: .tasksCount)
        self.benefitsContainer = TitleValueContainer(type: .benefitsCount)
        self.priceContainer = TitleValueContainer(type: .price)

        let containersStackView = UIStackView(arrangedSubviews: [
            self.tasksContainer,
            self.benefitsContainer,
            self.priceContainer
        ])
        containersStackView.alignment = .fill
        containersStackView.distribution = .fillEqually

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(containersStackView)

        self.iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(30)
        }

        containersStackView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(10)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.height.equalTo(45)
        }
    }

    private func setupAppearance() {

        self.backgroundColor = .clear
        self.selectionStyle = .none
    }

    // MARK: - Configure

    private func configureTitleLabel() -> BULabel {

        let label = BULabel()

        label.font = UIFont.avenirHeavy(30)

        return label
    }

    private func configureIconImageView() -> UIImageView {

        let iv = UIImageView()

        iv.contentMode = .scaleAspectFit

        return iv
    }

    private func configureSeparator() -> UIView {

        let separator = UIView()

        separator.theme_backgroundColor = Colors.grayTextColor

        return separator
    }
}

fileprivate class TitleValueContainer: UIView {

    enum ContainerType: String {

        case price = "ui_price_title"
        case benefitsCount = "ui_benefits_count_title"
        case tasksCount = "ui_tasks_count_title"
    }

    // MARK: - Init

    init(type: ContainerType) {

        super.init(frame: .zero)

        self.setupSubviews()
        self.setupAppearance()

        self.titleLabel.nonlocalizedTitle = type.rawValue
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public variables

    var value: String? {

        didSet {

            self.valueLabel.text = value
        }
    }

    var valueColor: UIColor? {

        didSet {

            self.valueLabel.textColor = valueColor ?? .red
        }
    }

    // MARK: - UI variables

    private var titleLabel: BULabel!
    private var valueLabel: UILabel!

    // MARK: - Setup

    private func setupSubviews() {

        self.titleLabel = self.configureTitleLabel()
        self.valueLabel = self.configureValueLabel()

        self.addSubview(self.titleLabel)
        self.addSubview(self.valueLabel)

        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(20)
        }

        self.valueLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(self.titleLabel.snp.bottom).offset(5)
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }

    private func setupAppearance() {

        self.backgroundColor = .clear
    }

    // MARK: - Configure

    private func configureTitleLabel() -> BULabel {

        let label = BULabel()

        label.textAlignment = .center
        label.font = UIFont.avenirHeavy(20)
        label.theme_textColor = Colors.defaultTextColor

        return label
    }

    private func configureValueLabel() -> UILabel {

        let label = UILabel()

        label.textAlignment = .center
        label.font = UIFont.avenirRoman(16)

        return label
    }
}
