//
//  BUAmountSetter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

final class BUAmountSetter: UIView {

    // MARK: - Init

    init(initValue: Int, minValue: Int, maxValue: Int, stepValue: Int) {

        self.minValue = minValue
        self.maxValue = maxValue
        self.initValue = initValue
        self.stepValue = stepValue

        super.init(frame: .zero)

        self.setupSubviews()
        self.setupAppearance()
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Value variables

    private let minValue: Int
    private let maxValue: Int
    private let initValue: Int
    private let stepValue: Int

    private(set) var currValue: Int = 0 {

        didSet {

            self.valueLabel.text = "\(self.currValue)"
        }
    }

    var onValueChanged: ((Int) -> Void)?

    // MARK: - UI variables

    private var minusButton: UIButton!
    private var plusButton: UIButton!
    private var valueLabel: UILabel!

    // MARK: - Setup

    private func setupSubviews() {

        self.valueLabel = self.configureValueLabel()
        self.minusButton = self.configureMinusButton()
        self.plusButton = self.configurePlusButton()

        self.addSubview(self.minusButton)
        self.addSubview(self.valueLabel)
        self.addSubview(self.plusButton)

        self.minusButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(40)
        }

        self.plusButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.size.equalTo(40)
        }

        self.valueLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(self.minusButton.snp.trailing).offset(10)
            make.trailing.equalTo(self.plusButton.snp.leading).offset(-10)
            make.width.equalTo(100)
        }
    }

    private func setupAppearance() {

        self.backgroundColor = UIColor.clear
    }

    // MARK: - Configure

    private func configureMinusButton() -> UIButton {

        let button = UIButton(type: .system)

        button.setImage(AssetsHelper.shared.image(.minusIcon), for: .normal)
        button.theme_tintColor = Colors.defaultTextColor
        button.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)

        return button
    }

    private func configurePlusButton() -> UIButton {

        let button = UIButton(type: .system)

        button.setImage(AssetsHelper.shared.image(.plusIcon), for: .normal)
        button.theme_tintColor = Colors.defaultTextColor
        button.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)

        return button
    }

    private func configureValueLabel() -> UILabel {

        let label = UILabel()

        label.theme_textColor = Colors.defaultTextColor
        label.font = UIFont.avenirRoman(16)
        label.textAlignment = .center

        return label
    }

    // MARK: - Selectors

    @objc private func plusTapped() {

        if self.currValue + self.stepValue <= self.maxValue {

            self.currValue += self.stepValue
        }

        self.plusButton.isEnabled = self.currValue <= self.maxValue

        self.onValueChanged?(self.currValue)
    }

    @objc private func minusTapped() {

        if self.currValue - self.stepValue >= self.minValue {

            self.currValue -= self.stepValue
        }

        self.minusButton.isEnabled = self.currValue >= self.minValue

        self.onValueChanged?(self.currValue)
    }
}
