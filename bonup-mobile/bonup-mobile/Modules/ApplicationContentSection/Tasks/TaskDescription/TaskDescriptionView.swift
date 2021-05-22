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
        case call, visitSite
    }

    enum DateContainerType {
        case from, to
    }

    // MARK: - Public variables

    var presenter: ITaskDescriptionPresenter!

    // MARK: - Private variables

    private var scrollView: UIScrollView!
    private var scrollContentView: UIView!
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var organizationTitleLabel: UILabel!
    private var categoryLabel: UILabel!
    private var dateFromLabel: UILabel!
    private var dateToLabel: UILabel!
    private var ballsCountLabel: UILabel!
    private var callButton: UIButton!
    private var siteButton: UIButton!
    private var adBanner: BUAdBanner!
    private var mapView: BUMapView!
    private var qrImageView: UIImageView!

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

        self.ballsCountLabel = self.configureTitleLabel()
        self.imageView.addSubview(self.ballsCountLabel)
        self.ballsCountLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(10.0)
        }

        self.categoryLabel = self.configureCategoryLabel()
        self.imageView.addSubview(self.categoryLabel)
        self.categoryLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(self.ballsCountLabel.snp.bottom).offset(10.0)
        }

        self.titleLabel = self.configureTitleLabel()
        self.scrollContentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(self.imageView.snp.bottom).offset(10.0)
        }

        self.descriptionLabel = self.configureDescriptionLabel()
        self.scrollContentView.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15.0)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10.0)
        }

        let firstSeparatorView = self.configureSeparatorView()
        self.scrollContentView.addSubview(firstSeparatorView)
        firstSeparatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40.0)
            make.height.equalTo(1.0)
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(10.0)
        }

        self.organizationTitleLabel = self.configureTitleLabel()
        self.scrollContentView.addSubview(self.organizationTitleLabel)
        self.organizationTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.bottom.equalTo(firstSeparatorView.snp.bottom).offset(10.0)
        }

        let buttonsStackView = self.congfigureStackView()
        self.scrollContentView.addSubview(buttonsStackView)
        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(firstSeparatorView.snp.bottom).offset(10.0)
            make.height.equalTo(30.0)
        }

        self.callButton = self.configureButton(for: .call)
        self.siteButton = self.configureButton(for: .visitSite)

        [self.callButton, self.siteButton].forEach { buttonsStackView.addArrangedSubview($0) }

        let secondSeparatorView = self.configureSeparatorView()
        self.scrollContentView.addSubview(secondSeparatorView)
        secondSeparatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40.0)
            make.height.equalTo(1.0)
            make.top.equalTo(buttonsStackView.snp.bottom).offset(10.0)
        }

        self.dateFromLabel = self.configureDescriptionLabel()
        self.dateToLabel = self.configureDescriptionLabel()
        let fromDateContainer = self.configureDateContainer(for: .from)
        let toDateContainer = self.configureDateContainer(for: .to)
        let dateContainer = self.configureHorizontalContainerView(
            first: fromDateContainer,
            second: toDateContainer
        )
        self.scrollContentView.addSubview(dateContainer)
        dateContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.top.equalTo(secondSeparatorView.snp.bottom).offset(10.0)
        }

        let thirdSeparator = self.configureSeparatorView()
        self.scrollContentView.addSubview(thirdSeparator)
        thirdSeparator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40.0)
            make.top.equalTo(dateContainer.snp.bottom).offset(10.0)
            make.height.equalTo(1.0)
        }

        self.qrImageView = self.configureQrImageView()
        self.scrollContentView.addSubview(self.qrImageView)
        self.qrImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(70.0)
            make.top.equalTo(thirdSeparator.snp.bottom).offset(10.0)
            make.height.equalTo(self.qrImageView.snp.width)
        }

        let fourthSeparator = self.configureSeparatorView()
        self.scrollContentView.addSubview(fourthSeparator)
        fourthSeparator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40.0)
            make.top.equalTo(self.qrImageView.snp.bottom).offset(10.0)
            make.height.equalTo(1.0)
        }

        self.mapView = self.configureMapView()
        self.scrollContentView.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.top.equalTo(fourthSeparator.snp.bottom).offset(40.0)
            make.height.equalTo(self.mapView.snp.width)
        }

        self.adBanner = BUAdBanner(rootViewController: self)
        self.scrollContentView.addSubview(self.adBanner)
        self.adBanner.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mapView.snp.bottom).offset(10.0)
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
        
        return BUMapView()
    }

    private func configureHorizontalContainerView(first: UIView, second: UIView) -> UIView {
        let view = UIView()

        view.addSubview(first)
        first.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
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
            title.text = "ui_from_date".localized
            value = self.dateFromLabel
        case .to:
            title.text = "ui_to_date".localized
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
            make.bottom.equalToSuperview().offset(-10.0)
        }

        title.textAlignment = .center
        value.textAlignment = .center

        return view
    }

    private func configureButton(for type: OrganizationButtonType) -> UIButton {
        let button = UIButton(type: .system)

        var title = ""
        switch type {
        case .call:
            title = "ui_call".localized
            button.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        case .visitSite:
            title = "ui_visit_site".localized
            button.addTarget(self, action: #selector(visitSiteButtonTapped), for: .touchUpInside)
        }

        let attributedTitle = NSAttributedString.with(
            title: title,
            textColor: .purpleLite,
            font: UIFont.avenirRoman(15.0)
        )

        button.setAttributedTitle(attributedTitle, for: .normal)

        return button
    }

    private func congfigureStackView() -> UIStackView {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0

        return stackView
    }

    private func configureImageView() -> UIImageView {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }

    private func configureTitleLabel() -> UILabel {
        let label = UILabel()

        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.font = UIFont.avenirHeavy(20.0)
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }

    private func configureDescriptionLabel() -> UILabel {
        let label = UILabel()

        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.font = UIFont.avenirRoman(15.0)
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
        self.ballsCountLabel.text = self.presenter.balls
        self.dateFromLabel.text = self.presenter.fromDate
        self.dateToLabel.text = self.presenter.toDate
        self.categoryLabel.text = self.presenter.categoryTitle
        self.qrImageView.image = self.presenter.qrCodeImage

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
