//
//  TaskDescriptionView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 06.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit
import GoogleMobileAds
import YandexMapsMobile
import Nuke

protocol ITaskDescriptionView: AnyObject {
    func reloadData()
}

final class TaskDescriptionView: BUContentViewController {

    enum OrganizationButtonType {
        case phone, webSite, vk
    }

    enum DateContainerType {
        case from, to
    }

    // MARK: - Public variables

    var presenter: ITaskDescriptionPresenter!

    // MARK: - UI variables

    private var scrollView: UIScrollView!
    private var scrollContentView: UIView!
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var organizationTitleLabel: BULabel!
    private var organizationNameLabel: UILabel!
    private var organizationDirectorLabel: UILabel!
    private var organizationAddressLabel: UILabel!
    private var categoryLabel: BULabel!
    private var categoryContainer: UIView!
    private var dateFromLabel: UILabel!
    private var dateToLabel: UILabel!
    private var ballsCountLabel: UILabel!
    private var ballsCountContainer: UIView!
    private var callButton: UIButton!
    private var siteButton: UIButton!
    private var vkButton: UIButton!
    private var adBanner: BUAdBanner!
    private var mapView: BUMapView!
    private var qrCodeView: BUQRCodeView!
    
    // MARK: - State variables
    
    private var isFirstLayout = true

    // MARK: - Life cycle

    override func loadView() {
        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBar()
        self.setupAppearance()
        self.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if self.isFirstLayout {
            
            self.isFirstLayout.toggle()
            
            self.categoryContainer.setupBlur()
            self.ballsCountContainer.setupBlur()
        }
    }

    // MARK: - Setup subviews

    private func setupSubviews() {
        self.scrollView = UIScrollView()
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.scrollContentView = UIView()
        self.scrollView.addSubview(self.scrollContentView)
        self.scrollContentView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }

        self.imageView = self.configureImageView()
        self.scrollContentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(self.imageView.snp.width).dividedBy(2)
        }

        self.ballsCountContainer = self.configureBallsCountContainer()
        self.imageView.addSubview(self.ballsCountContainer)
        self.ballsCountContainer.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
        
        self.categoryContainer = self.configureCategoryContainer()
        self.imageView.addSubview(self.categoryContainer)
        self.categoryContainer.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
        }

        let taskInfoContainer = UIView()
        taskInfoContainer.setupSectionStyle()
        self.scrollContentView.addSubview(taskInfoContainer)
        taskInfoContainer.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(20.0)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.titleLabel = self.configureTitleLabel()
        taskInfoContainer.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25.0)
            make.top.equalToSuperview().offset(10)
        }

        self.descriptionLabel = self.configureDescriptionLabel()
        taskInfoContainer.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15.0)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10.0)
            make.bottom.equalToSuperview().offset(-10)
        }

        let companyInfoContainer = UIView()
        companyInfoContainer.setupSectionStyle()
        self.scrollContentView.addSubview(companyInfoContainer)
        companyInfoContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(taskInfoContainer.snp.bottom).offset(20)
        }
        
        self.organizationTitleLabel = self.configureTitleLabel()
        companyInfoContainer.addSubview(self.organizationTitleLabel)
        self.organizationTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10.0)
            make.leading.trailing.equalToSuperview().offset(20)
        }
        
        self.organizationNameLabel = self.configureDetailsLabel()
        companyInfoContainer.addSubview(self.organizationNameLabel)
        self.organizationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.organizationTitleLabel.snp.bottom).offset(20.0)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        self.organizationDirectorLabel = self.configureDetailsLabel()
        companyInfoContainer.addSubview(self.organizationDirectorLabel)
        self.organizationDirectorLabel.snp.makeConstraints { make in
            make.top.equalTo(self.organizationNameLabel.snp.bottom).offset(10.0)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        self.organizationAddressLabel = self.configureDetailsLabel()
        companyInfoContainer.addSubview(self.organizationAddressLabel)
        self.organizationAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(self.organizationDirectorLabel.snp.bottom).offset(10.0)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        let companyInfoSeparator = self.configureSeparatorView()
        companyInfoContainer.addSubview(companyInfoSeparator)
        companyInfoSeparator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(1)
            make.top.equalTo(self.organizationAddressLabel.snp.bottom).offset(10)
        }

        let buttonsStackView = self.congfigureStackView()
        companyInfoContainer.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(companyInfoSeparator.snp.bottom).offset(10.0)
            make.height.equalTo(40.0)
            make.bottom.equalToSuperview().offset(-10)
        }

        self.callButton = self.configureButton(for: .phone)
        self.siteButton = self.configureButton(for: .webSite)
        self.vkButton = self.configureButton(for: .vk)

        [self.callButton, self.siteButton, self.vkButton].forEach {
            
            guard let button = $0 else { return }
            
            buttonsStackView.addArrangedSubview(button);
            button.snp.makeConstraints { $0.size.equalTo(40) }
        }
        
        let dateInfoContainer = UIView()
        dateInfoContainer.setupSectionStyle()
        self.scrollContentView.addSubview(dateInfoContainer)
        dateInfoContainer.snp.makeConstraints { make in
            make.top.equalTo(companyInfoContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        self.dateFromLabel = self.configureDescriptionLabel()
        self.dateToLabel = self.configureDescriptionLabel()
        let fromDateContainer = self.configureDateContainer(for: .from)
        let toDateContainer = self.configureDateContainer(for: .to)
        let dateContainer = self.configureHorizontalContainerView(
            first: fromDateContainer,
            second: toDateContainer
        )
        dateInfoContainer.addSubview(dateContainer)
        dateContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        let mapContainer = UIView()
        mapContainer.setupSectionStyle()
        self.scrollContentView.addSubview(mapContainer)
        mapContainer.snp.makeConstraints { make in
            make.top.equalTo(dateInfoContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        self.mapView = self.configureMapView()
        mapContainer.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.width.equalTo(self.mapView.snp.height)
        }
        
        self.qrCodeView = BUQRCodeView()
        self.scrollContentView.addSubview(self.qrCodeView)
        self.qrCodeView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.mapView.snp.bottom).offset(30)
            make.height.equalTo(self.qrCodeView.snp.width)
        }

        self.adBanner = BUAdBanner(rootViewController: self)
        self.scrollContentView.addSubview(self.adBanner)
        self.adBanner.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.qrCodeView.snp.bottom).offset(20.0)
            make.width.equalTo(320)
            make.height.equalTo(50)
            make.bottom.equalTo(self.scrollContentView).offset(-30.0)
        }
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        
        self.loc_title = "ui_task_details"
        
        let item = BUBarButtonItem(loc_title: "ui_details_title",
                                   style: .plain,
                                   target: self,
                                   action: #selector(detailsTapped))
        
        self.navigationItem.rightBarButtonItem = item
    }
    
    private func setupAppearance() {
        
        self.view.theme_backgroundColor = Colors.backgroundColor
    }

    // MARK: - Configure
    
    private func configureBallsCountContainer() -> UIView {
        
        let container = UIView()
        container.backgroundColor = .clear
        
        self.ballsCountLabel = self.configureInfoLabel()
        
        container.addSubview(self.ballsCountLabel)
        self.ballsCountLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        container.layer.maskedCorners = [.layerMinXMaxYCorner]
        container.layer.cornerRadius = 20
        container.layer.masksToBounds = true
        
        return container
    }
    
    private func configureCategoryContainer() -> UIView {
        
        let container = UIView()
        container.backgroundColor = .clear
        
        self.categoryLabel = self.configureInfoLabel()
        
        container.addSubview(self.categoryLabel)
        self.categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        container.layer.maskedCorners = [.layerMinXMinYCorner]
        container.layer.cornerRadius = 20
        container.layer.masksToBounds = true
        
        return container
    }
    
    private func configureDetailsLabel() -> UILabel {
        
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .avenirRoman(15)
        label.theme_textColor = Colors.defaultTextColorWithAlpha
        
        return label
    }
    
    private func configureInfoLabel() -> BULabel {
        
        let label = BULabel()
        
        label.textAlignment = .center
        label.font = .avenirHeavy(17)
        label.textColor = .orange.withAlphaComponent(0.8)
        
        return label
    }
    
    private func configureQrImageView() -> UIImageView {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit

        return imageView
    }

    private func configureCategoryLabel() -> UILabel {
        let label = UILabel()

        label.textColor = UIColor.black
        label.font = UIFont.avenirHeavy(20.0)
        label.textAlignment = .right
        label.numberOfLines = 1

        return label
    }

    private func configureMapView() -> BUMapView {
        
        let mapView = BUMapView()
        
        mapView.layer.cornerRadius = 20
        mapView.layer.masksToBounds = true
        
        return mapView
    }

    private func configureHorizontalContainerView(first: UIView, second: UIView) -> UIView {
        let view = UIView()

        view.addSubview(first)
        first.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        let separator = self.configureSeparatorView()
        view.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(1)
        }

        view.addSubview(second)
        second.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(first.snp.trailing)
        }

        return view
    }

    private func configureDateContainer(for type: DateContainerType) -> UIView {
        let view = UIView()

        let title = self.configureTitleLabel()
        var value: UILabel
        switch type {
        case .from:
            title.loc_text = "ui_from_date"
            value = self.dateFromLabel
        case .to:
            title.loc_text = "ui_to_date"
            value = self.dateToLabel
        }

        view.addSubview(title)
        title.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }

        view.addSubview(value)
        value.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(10.0)
            make.bottom.equalToSuperview()
        }

        title.textAlignment = .center
        value.textAlignment = .center

        return view
    }

    private func configureButton(for type: OrganizationButtonType) -> UIButton {
        let button = UIButton(type: .system)

        var image: UIImage
        
        switch type {
        case .phone:
            image = AssetsHelper.shared.image(.phoneIcon)!
            button.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
            
        case .webSite:
            image = AssetsHelper.shared.image(.webIcon)!
            button.addTarget(self, action: #selector(visitSiteButtonTapped), for: .touchUpInside)
            
        case .vk:
            image = AssetsHelper.shared.image(.vkIcon)!
            button.addTarget(self, action: #selector(visitVKButtonTapped), for: .touchUpInside)
        }

        button.setImage(image, for: .normal)
        button.theme_tintColor = Colors.defaultTextColor

        return button
    }

    private func congfigureStackView() -> UIStackView {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 30

        return stackView
    }

    private func configureImageView() -> UIImageView {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }

    private func configureTitleLabel() -> BULabel {
        let label = BULabel()

        label.theme_textColor = Colors.defaultTextColor
        label.font = UIFont.avenirRoman(15)
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }

    private func configureDescriptionLabel() -> UILabel {
        let label = UILabel()

        label.theme_textColor = Colors.defaultTextColorWithAlpha
        label.font = UIFont.avenirRoman(20.0)
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }

    private func configureSeparatorView() -> UIView {
        let view = UIView()

        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)

        return view
    }

    // MARK: - Selectors

    @objc private func callButtonTapped() {
        // Use phone number when back will be ready
        if let url = URL(string: "telprompt://mobile") {
          if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @objc private func visitVKButtonTapped() {
        
    }

    @objc private func visitSiteButtonTapped() {
        // Use url when back will be ready
        if let url = URL(string: "https://google.com") {
                 if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.openURL(url)
                 }
               }
    }
    
    @objc private func detailsTapped() {
        
        self.presenter.handleDetailsTap()
    }
}

// MARK: - ITaskDescriptionView

extension TaskDescriptionView: ITaskDescriptionView {
    func reloadData() {
        self.titleLabel.text = self.presenter.title
        self.descriptionLabel.text = self.presenter.description
        
        self.organizationTitleLabel.loc_text = "ui_organization_title"
        self.organizationNameLabel.text = presenter.organizationTitle
        self.organizationAddressLabel.text = presenter.address
        self.organizationDirectorLabel.text = presenter.director
        
        self.ballsCountLabel.text = self.presenter.balls
        self.dateFromLabel.text = self.presenter.fromDate
        self.dateToLabel.text = self.presenter.toDate
        self.categoryLabel.loc_text = self.presenter.categoryTitle
        self.qrCodeView.code = self.presenter.qrCode

        // setup map
        let point = YMKPoint(
            latitude: self.presenter.latitude,
            longitude: self.presenter.longitude
        )

        let placemark = self.mapView.mapWindow.map.mapObjects.addPlacemark(with: point)
        placemark.opacity = 0.5
        placemark.isDraggable = true
        placemark.setIconWith(UIImage(named: "map-mark")!)

        self.mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: point, zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)

        // setup image
        let options = ImageLoadingOptions(
            placeholder: UIImage(named: ""),
            transition: .fadeIn(duration: 0.33)
        )
        if let url = self.presenter.imageURL {
            let imageRequst = ImageRequest(url: url)
            Nuke.loadImage(
                with: imageRequst,
                options: options,
                into: self.imageView,
                progress: nil,
                completion: nil
            )
        }
    }
}
