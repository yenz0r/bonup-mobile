//
//  SelectedBenefitsContentCell.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 28.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

final class SelectedBenefitsContentCell: BenefitsContentCell {

    enum LabelType {
        case title, description, coast
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

    var coastText: String? {
        didSet {
            guard let coastStr = self.coastText, let coast = Int(coastStr) else {
                self.coastLabel.text = self.coastText
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

            self.coastLabel.text = coastStr
            self.coastLabel.textColor = color
        }
    }

    // MARK: - Private UI variables

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var coastLabel: UILabel!

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

        self.titleLabel = self.configureLabel(for: .title)
        self.descriptionLabel = self.configureLabel(for: .description)
        self.coastLabel = self.configureLabel(for: .coast)

        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.coastLabel)

        self.titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8.0)
            make.leading.equalToSuperview().inset(15.0)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8.0)
            make.leading.trailing.equalToSuperview().inset(8.0)
        }

        self.coastLabel.snp.makeConstraints { make in
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
            label.theme_textColor = Colors.defaultTextColor
            label.textAlignment = .left
            
        case .description:
            label.font = UIFont.avenirRoman(15.0)
            label.theme_textColor = Colors.defaultTextColorWithAlpha
            label.textAlignment = .left
            
        case .coast:
            label.font = UIFont.avenirHeavy(10.0)
            label.theme_textColor = Colors.defaultTextColorWithAlpha
            label.textAlignment = .right
        }
        
        label.numberOfLines = 0

        return label
    }
}
