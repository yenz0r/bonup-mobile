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

    // MARK: - UI variables

    private var sectionTitleLabel: UILabel!
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
        self.setupAppearance()
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

    // MARK: - Setup
    
    private func setupAppearance() {
        
        self.setupSectionStyle()
    }

    private func setupSubviews() {
        
        self.sectionTitleLabel = self.configureSectionTitleLabel()
        self.addSubview(self.sectionTitleLabel)
        
        self.doneTitleLabel = self.configureTitleLabel(with: "ui_done_title")
        self.doneValueLabel = self.configureValueLabel()
        self.doneContainerView = self.configureContainer(
            self.doneTitleLabel,
            self.doneValueLabel,
            separatorPosition: .right
        )

        self.earnedTitleLabel = self.configureTitleLabel(with: "ui_earned_title")
        self.earnedValueLabel = self.configureValueLabel()
        self.earnedContainerView = self.configureContainer(
            self.earnedTitleLabel,
            self.earnedValueLabel,
            separatorPosition: .none
        )

        self.spendTitleLabel = self.configureTitleLabel(with: "ui_spend_title")
        self.spendValueLabel = self.configureValueLabel()
        self.spendContainerView = self.configureContainer(
            self.spendTitleLabel,
            self.spendValueLabel,
            separatorPosition: .left
        )

        self.sectionTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(10)
        }
        
        self.stackView = self.configureStackView()
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            
            make.top.equalTo(self.sectionTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }

        self.stackView.addArrangedSubview(self.doneContainerView)
        self.stackView.addArrangedSubview(self.earnedContainerView)
        self.stackView.addArrangedSubview(self.spendContainerView)
    }

    // MARK: - Configure subviews
    
    private func configureSectionTitleLabel() -> UILabel {
        
        let label = BULabel()
        
        label.theme_textColor = Colors.defaultTextColorWithAlpha
        label.font = .avenirRoman(15)
        label.loc_text = "ui_profile_bonuses_label"
        
        return label
    }

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
            make.top.equalTo(title.snp.bottom).offset(10)
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
        let label = BULabel()

        label.textAlignment = .center
        label.loc_text = text
        label.font = UIFont.avenirHeavy(15.0)
        label.theme_textColor = Colors.defaultTextColor

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
        label.theme_textColor = Colors.defaultTextColorWithAlpha

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
