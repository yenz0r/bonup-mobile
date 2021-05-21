//
//  CompaniesSearchView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import YandexMapsMobile

protocol ICompaniesSearchView: AnyObject {

    func reloadMap()
}

final class CompaniesSearchView: BUContentViewController {

    // MARK: - Public variables

    var presenter: CompaniesSearchPresenter!

    // MARK: - UI variabes

    private var mapView: BUMapView!
    private var selectCategoriesContainer: SelectCategoriesContainer!
    private var searchBar: BUSearchBar!
    
    // MARK: - State variables
    
    private var placemarkCollection: YMKClusterizedPlacemarkCollection?

    // MARK: - Life cycle

    override func loadView() {

        self.view = UIView()

        self.setupSubviews()
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.setupAppearance()
        self.setupMapItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        self.presenter.refreshData()
    }

    // MARK: - Setup
    
    private func setupMapItems() {
        
        self.placemarkCollection = self.mapView
            .mapWindow
            .map
            .mapObjects
            .addClusterizedPlacemarkCollection(with: self)
        
        self.placemarkCollection?.addTapListener(with: self)
    }

    private func setupSubviews() {

        self.mapView = self.configureMapView()
        self.searchBar = self.configureSearchBar()
        self.selectCategoriesContainer = self.configureSelectCategoriesContainer()

        self.view.addSubview(self.mapView)
        self.mapView.addSubview(self.searchBar)
        self.mapView.addSubview(self.selectCategoriesContainer)

        self.mapView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.mapView).inset(20)
        }
        
        self.selectCategoriesContainer.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.mapView.safeAreaLayoutGuide)
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

        let dataSource = SelectCategoriesDataSource(selectedCategories: InterestCategories.allCases,
                                                    selectionMode: .multiple)
        let container = SelectCategoriesContainer(delegate: self, dataSource: dataSource)

        return container
    }
    
    private func configureSearchBar() -> BUSearchBar {
        
        let bar = BUSearchBar()
        
        bar.loc_placeholder = "ui_search_company_placeholder"
        bar.onSearchChange = { [weak self] searchText in
            
            self?.presenter.handleSearchValueUpdate(searchText)
        }
        
        return bar
    }
}

// MARK: - SelectCategoriesContainerDelegate

extension CompaniesSearchView: SelectCategoriesContainerDelegate {

    func selectCategoriesContainerDidUpdateCategoriesList(_ container: SelectCategoriesContainer) {

        self.presenter.handleCategoriesUpdate(categories: container.dataSource.selectedCategories)
    }
}

// MARK: - YMKClusterListener

extension CompaniesSearchView: YMKClusterListener {
    
    func onClusterAdded(with cluster: YMKCluster) { }
}

// MARK: - YMKMapObjectTapListener

extension CompaniesSearchView: YMKMapObjectTapListener {
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        
        guard let userPoint = mapObject as? YMKPlacemarkMapObject,
              let userData = userPoint.userData else {
            
            return false
        }
        
        if let companyTitle = userData as? String {
        
            self.presenter.handleCompanySelection(companyTitle)
        }
        
        return true
    }
}

// MARK: - ICompaniesSearchView

extension CompaniesSearchView: ICompaniesSearchView {
    
    func reloadMap() {
        
        self.placemarkCollection?.clear()
        
        for (index, company) in self.presenter.companies().enumerated() {
            
            let point = YMKPoint(latitude: company.latitude, longitude: company.longitude)
            
            let placemark = self.placemarkCollection?.addPlacemark(
                with: point,
                image: AssetsHelper
                        .shared
                        .image(.companyLocationMapIcon)!
                        .resizedImage(targetSize: CGSize(width: 70, height: 70)),
                style: .init()
            )
            
            placemark?.userData = company.title
            
            // TEST
            if index == 0 {
                
                self.mapView.mapWindow.map.move(
                    with: YMKCameraPosition(target: point, zoom: 13, azimuth: 0, tilt: 0),
                    animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1.5),
                    cameraCallback: nil
                )
            }
        }
        
        if let userLocation = self.presenter.userLocation() {
            
            let userPoint = YMKPoint(latitude: userLocation.latitude,
                                     longitude: userLocation.longitude)
            
            let placemark = self.placemarkCollection?.addPlacemark(
                with: userPoint,
                image: AssetsHelper
                    .shared
                    .image(.userLocationMapIcon)!
                    .resizedImage(targetSize: CGSize(width: 70, height: 70)),
                style: .init())
            
            placemark?.userData = nil
            
//            self.mapView.mapWindow.map.move(
//                with: YMKCameraPosition(target: userPoint, zoom: 13, azimuth: 0, tilt: 0),
//                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 3),
//                cameraCallback: nil
//            )
        }
        
        self.placemarkCollection?.clusterPlacemarks(withClusterRadius: 15, minZoom: 15)
    }
}
