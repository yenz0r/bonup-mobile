//
//  BenefitDescriptionView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 10.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IBenefitDescriptionView: AnyObject {
    
    func setupQrCode(_ code: String)
    func setupTitle(_ title: String?)
    func setupDescription(_ descriptionText: String?)
    func setupImage(_ link: String?)
}

final class BenefitDescriptionView: BUContentViewController {

    enum LabelType {
        case title, description, sectionTitle
    }

    // MARK: - Public variables

    var presenter: IBenefitDescriptionPresenter!

    // MARK: - User interface variables

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var qrCodeView: BUQRCodeView!
    private var imageView: BULoadImageView!

    // MARK: - Life cycle

    override func loadView() {
        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.setupNavigationBar()
        self.presenter.viewDidLoad()
    }

    // MARK: - Setup subviews

    private func setupSubviews() {

        self.titleLabel = self.configureLabel(for: .title)
        self.descriptionLabel = self.configureLabel(for: .description)
        self.qrCodeView = BUQRCodeView()
        self.qrCodeView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        self.imageView = self.configureImageView()
        let infoContainer = self.configureSectionContainer()
        let infoContainerTitleLabel = self.configureLabel(for: .sectionTitle)

        self.view.addSubview(self.imageView)
        self.view.addSubview(infoContainer)
        infoContainer.addSubview(infoContainerTitleLabel)
        infoContainer.addSubview(self.titleLabel)
        infoContainer.addSubview(self.descriptionLabel)
        self.view.addSubview(self.qrCodeView)
        
        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(200.0)
        }
        
        infoContainer.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(100)
        }
        
        infoContainerTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(10)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.top.equalTo(infoContainerTitleLabel.snp.bottom).offset(15.0)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8.0)
            make.bottom.equalToSuperview().offset(-10)
        }

        self.qrCodeView.snp.makeConstraints { make in
            make.top.equalTo(infoContainer.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(self.qrCodeView.snp.width)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-50)
        }
    }

    // MARK: - Setup

    private func setupAppearance() {
        
        self.view.theme_backgroundColor = Colors.backgroundColor
    }
    
    private func setupNavigationBar() {
        
        self.loc_title = "ui_benefits_title"
    }

    // MARK: - Configure
    
    private func configureImageView() -> BULoadImageView {
        
        let imageView = BULoadImageView()

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }
    
    private func configureSectionContainer() -> UIView {
        
        let container = UIView()
        
        container.backgroundColor = .clear
        container.setupSectionStyle()
        container.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        return container
    }

    private func configureLabel(for type: LabelType) -> UILabel {
        let label = BULabel()

        switch type {
        
        case .sectionTitle:
            label.textAlignment = .left
            label.font = .avenirHeavy(14)
            label.theme_textColor = Colors.defaultTextColorWithAlpha
            label.loc_text = "ui_company_description_info_label"
            
        case .title:
            label.textAlignment = .left
            label.font = UIFont.avenirHeavy(20.0)
            label.theme_textColor = Colors.defaultTextColor
            
        case .description:
            label.textAlignment = .left
            label.font = UIFont.avenirRoman(17.0)
            label.theme_textColor = Colors.defaultTextColorWithAlpha
        }

        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        return label
    }

    private func configureSeparatorView() -> UIView {
        let separator = UIView()

        separator.backgroundColor = UIColor.purpleLite.withAlphaComponent(0.2)

        return separator
    }
}

extension BenefitDescriptionView: IBenefitDescriptionView {

    func setupQrCode(_ code: String) {
        
        self.qrCodeView.code = code
    }

    func setupTitle(_ title: String?) {
        self.titleLabel.text = title
    }

    func setupDescription(_ descriptionText: String?) {
        self.descriptionLabel.text = descriptionText
    }

    func setupImage(_ link: String?) {
        guard let link = link else { return }
        guard let url = URL(string: link) else { return }

        self.imageView.loadFrom(url: url)
    }
}
