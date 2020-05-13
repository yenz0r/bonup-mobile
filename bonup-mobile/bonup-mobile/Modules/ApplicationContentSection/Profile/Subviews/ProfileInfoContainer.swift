//
//  ProfileInfoContainer.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 20.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ProfileInfoContainerDataSource: AnyObject {
    func profileInfoContainer(_ container: ProfileInfoContainer,
                              valueFor type: ProfileInfoContainer.InfoType) -> String
}

final class ProfileInfoContainer: UIView {

    enum SeparatorPosition {
        case left, right, none
    }

    enum InfoType {
        case done, spend, rest
    }

    // MARK: - Public variables

    weak var dataSource: ProfileInfoContainerDataSource!

    // MARK: - Private variables

    private var doneTitleLabel: UILabel!
    private var doneValueLabel: UILabel!
    private var earnedTitleLabel: UILabel!
    private var earnedValueLabel: UILabel!
    private var spendTitleLabel: UILabel!
    private var spendValueLabel: UILabel!
    private var doneContainerView: UIView!
    private var earnedContainerView: UIView!
    private var spendContainerView: UIView!
    private var stackView: UIStackView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    func reloadData() {
        self.doneValueLabel.text = self.dataSource.profileInfoContainer(self, valueFor: .done)
        self.spendValueLabel.text = self.dataSource.profileInfoContainer(self, valueFor: .spend)
        self.earnedValueLabel.text = self.dataSource.profileInfoContainer(self, valueFor: .rest)
    }

    // MARK: - Setup subviews

    private func setupSubviews() {
        self.doneTitleLabel = self.configureTitleLabel(with: "ui_done_title".localized)
        self.doneValueLabel = self.configureValueLabel()
        self.doneContainerView = self.configureContainer(
            self.doneTitleLabel,
            self.doneValueLabel,
            separatorPosition: .right
        )

        self.earnedTitleLabel = self.configureTitleLabel(with: "ui_earned_title".localized)
        self.earnedValueLabel = self.configureValueLabel()
        self.earnedContainerView = self.configureContainer(
            self.earnedTitleLabel,
            self.earnedValueLabel,
            separatorPosition: .none
        )

        self.spendTitleLabel = self.configureTitleLabel(with: "ui_spend_title".localized)
        self.spendValueLabel = self.configureValueLabel()
        self.spendContainerView = self.configureContainer(
            self.spendTitleLabel,
            self.spendValueLabel,
            separatorPosition: .left
        )

        self.stackView = self.configureStackView()
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.stackView.addArrangedSubview(self.doneContainerView)
        self.stackView.addArrangedSubview(self.earnedContainerView)
        self.stackView.addArrangedSubview(self.spendContainerView)
    }

    // MARK: - Configure subviews

    private func configureContainer(_ title: UILabel,
                                    _ value: UILabel,
                                    separatorPosition: SeparatorPosition) -> UIView {

        let containerView = UIView()

        containerView.addSubview(title)
        containerView.addSubview(value)

        title.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(5.0)
        }

        value.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.width.equalTo(title)
        }

        switch separatorPosition {
        case .left:
            let separator = self.configureSeparatorView()
            containerView.addSubview(separator)
            separator.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.width.equalTo(1.0)
                make.top.bottom.equalToSuperview().inset(15.0)
            }
        case .right:
            let separator = self.configureSeparatorView()
            containerView.addSubview(separator)
            separator.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.width.equalTo(1.0)
                make.top.bottom.equalToSuperview().inset(15.0)
            }
        case .none:
            break
        }

        return containerView
    }

    private func configureTitleLabel(with text: String) -> UILabel {
        let label = UILabel()

        label.textAlignment = .center
        label.text = text
        label.font = UIFont.avenirHeavy(15.0)
        label.textColor = UIColor.black.withAlphaComponent(0.5)

        return label
    }

    private func configureSeparatorView() -> UIView {
        let separatorView = UIView()

        separatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)

        return separatorView
    }

    private func configureValueLabel() -> UILabel {
        let label = UILabel()

        label.textAlignment = .center
        label.font = UIFont.avenirRoman(12.0)
        label.textColor = UIColor.purpleLite.withAlphaComponent(0.6)

        return label
    }

    private func configureStackView() -> UIStackView {
        let stackView = UIStackView()

        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 5.0

        return stackView
    }
}
