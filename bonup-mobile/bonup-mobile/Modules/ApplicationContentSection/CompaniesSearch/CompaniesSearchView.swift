//
//  CompaniesSearchView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import YandexMapKit

protocol ICompaniesSearchView: AnyObject {

}

final class CompaniesSearchView: BUContentViewController {

    // MARK: - Public variables

    var presenter: CompaniesSearchPresenter!

    // MARK: - UI variabes

    private var mapView: BUMapView!
    private var selectCategoriesContainer: SelectCategoriesContainer!

    // MARK: - Life cycle

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.setupAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let point = YMKPoint(
            latitude: 20,
            longitude: 70
        )

        let placemark = self.mapView.mapWindow.map.mapObjects.addPlacemark(with: point)
        placemark.opacity = 0.5
        placemark.isDraggable = true
        placemark.setIconWith(UIImage(named: "map-mark")!)

        self.mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: point, zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }

    // MARK: - Localization

    override func setupLocalizableContent() {

    }

    // MARK: - Setup

    private func setupSubviews() {

        self.mapView = self.configureMapView()
        self.selectCategoriesContainer = self.configureSelectCategoriesContainer()

        self.view.addSubview(self.mapView)
        self.mapView.addSubview(self.selectCategoriesContainer)

        self.mapView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }

        self.selectCategoriesContainer.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.mapView.safeAreaLayoutGuide).inset(10)
            make.bottom.equalToSuperview().offset(-40)
        }
    }

    private func setupAppearance() {
    }

    // MARK: - Configure

    private func configureMapView() -> BUMapView {

        return BUMapView()
    }

    private func configureSelectCategoriesContainer() -> SelectCategoriesContainer {

        let dataSource = SelectCategoriesDataSource(isActiveByDefault: true)
        let container = SelectCategoriesContainer(delegate: self, dataSource: dataSource)

        return container
    }
}

// MARK: - SelectCategoriesContainerDelegate

extension CompaniesSearchView: SelectCategoriesContainerDelegate {

    func selectCategoriesContainerDidUpdateCategoriesList(_ container: SelectCategoriesContainer) {

        print(container.dataSource.selectedCategories)
    }
}

// MARK: - ISettingsParamsView

extension CompaniesSearchView: ICompaniesSearchView { }
