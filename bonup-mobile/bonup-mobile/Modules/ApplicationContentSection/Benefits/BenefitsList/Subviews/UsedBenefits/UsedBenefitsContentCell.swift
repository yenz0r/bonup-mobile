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

    var isDied: Bool? {
        didSet {
            guard let died = self.isDied else {
                self.indicatorView.backgroundColor = .red
                return
            }

            self.indicatorView.backgroundColor = died ? .red : .green
        }
    }

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
                self.dateOfUseLabel.text = "ui_no".localized
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
    private var indicatorView: UIView!

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
        self.dateOfUseLabel = self.configureLabel(for: .dateOfUse)
        self.indicatorView = self.configureIndicatorView()

        self.contentView.addSubview(self.indicatorView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.dateOfUseLabel)

        self.indicatorView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(25.0)
        }
        
        self.dateOfUseLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8.0)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dateOfUseLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(8.0)
            make.leading.equalTo(self.indicatorView.snp.trailing).offset(15.0)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
            make.leading.equalTo(self.indicatorView.snp.trailing).offset(15.0)
            make.bottom.equalToSuperview().offset(-8.0)
        }
    }

    // MARK: - Configure
    
    private func configureIndicatorView() -> UIView {
        
        let indicator = UIView()
        
        return indicator
    }

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
            
        case .dateOfUse:
            label.font = UIFont.avenirHeavy(10.0)
            label.theme_textColor = Colors.defaultTextColorWithAlpha
            label.textAlignment = .right
        }
        
        label.numberOfLines = 0

        return label
    }
}
