//
//  BenefitDescriptionView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 10.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import Nuke

protocol IBenefitDescriptionView: AnyObject {
    func setupQrCodeImage(_ image: UIImage?)
    func setupTitle(_ title: String?)
    func setupDescription(_ descriptionText: String?)
    func setupImage(_ link: String?)
}

final class BenefitDescriptionView: BUContentViewController {

    enum LabelType {
        case title, description
    }

    // MARK: - Public variables

    var presenter: IBenefitDescriptionPresenter!

    // MARK: - User interface variables

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var separatorView: UIView!
    private var qrImageView: UIImageView!
    private var imageView: UIImageView!

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
        self.separatorView = self.configureSeparatorView()
        self.qrImageView = self.configureImageView()
        self.imageView = self.configureImageView()

        self.view.addSubview(self.imageView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.separatorView)
        self.view.addSubview(self.qrImageView)

        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(150.0)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.top.equalTo(self.imageView.snp.bottom).offset(15.0)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8.0)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8.0)
        }

        self.separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40.0)
            make.bottom.equalTo(self.qrImageView.snp.top).offset(-8.0)
            make.height.equalTo(1.0)
        }

        self.qrImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50.0)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30.0)
            make.height.equalTo(self.qrImageView.snp.width)
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
    
    private func configureImageView() -> UIImageView {
        let imageView = UIImageView()

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }

    private func configureLabel(for type: LabelType) -> UILabel {
        let label = UILabel()

        switch type {
        case .title:
            label.textAlignment = .left
            label.font = UIFont.avenirRoman(25.0)
            label.textColor = UIColor.purpleLite.withAlphaComponent(0.8)
        case .description:
            label.textAlignment = .left
            label.font = UIFont.avenirRoman(20.0)
            label.textColor = UIColor.purpleLite.withAlphaComponent(0.3)
        }

        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)

        return label
    }

    private func configureSeparatorView() -> UIView {
        let separator = UIView()

        separator.backgroundColor = UIColor.purpleLite.withAlphaComponent(0.2)

        return separator
    }
}

extension BenefitDescriptionView: IBenefitDescriptionView {

    func setupQrCodeImage(_ image: UIImage?) {
        self.qrImageView.image = image
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

        let imageRequst = ImageRequest(url: url)
        Nuke.loadImage(
            with: imageRequst,
            options: ImageLoadingOptions(),
            into: self.imageView,
            progress: nil,
            completion: nil
        )
    }
}
