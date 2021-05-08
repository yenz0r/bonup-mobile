//
//  CompanySearchInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 16.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import CoreLocation

protocol ICompaniesSearchInteractor: AnyObject {

    var selectedCategories: [InterestCategories] { get set }
    var searchText: String? { get set }
    var organizations: [CompanyEntity] { get }
    var userLocation: (latitude: Double, longitude: Double)? { get }
    
    func loadOrganizations(completion: ((Bool) -> Void)?)
}

final class CompaniesSearchInteractor: NSObject {

    // MARK: - Public variables
    
    var selectedCategories: [InterestCategories] = InterestCategories.allCases
    var userLocation: (latitude: Double, longitude: Double)?
    var searchText: String?
    
    // MARK: - Private variables
    
    private lazy var networkService = MainNetworkProvider<CompaniesSearchService>()
    private var locationManager: CLLocationManager!
    private var loadedOrganizations = [CompanyEntity]()
    
    // MARK: - Init
    
    override init() {
        
        super.init()
        
        let manager = CLLocationManager()
        
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.distanceFilter = kCLLocationAccuracyHundredMeters
            manager.delegate = self
            manager.startUpdatingLocation()
        }
        
        self.locationManager = manager
    }
}

// MARK: - ISettingsInteractor implementation

extension CompaniesSearchInteractor: ICompaniesSearchInteractor {

    func loadOrganizations(completion: ((Bool) -> Void)?) {
        
//        guard let token = AccountManager.shared.currentToken else { completion?(false); return }
        
        _ = networkService.request(
            .loadCompanies(token: "token"),
            type: [CompanyEntity].self,
            completion: { [weak self] result in
                
                let organization = CompanyEntity(title: "title",
                                                 descriptionText: "description",
                                                 directorFirstName: "name",
                                                 directorSecondName: "second name",
                                                 directorLastName: "last name",
                                                 locationCountry: "country",
                                                 locationCity: "city",
                                                 locationStreet: "street",
                                                 locationHomeNumber: "10",
                                                 contactsPhone: "12312",
                                                 contactsVK: "vk",
                                                 contactsWebSite: "web",
                                                 latitude: 53.90898898436514,
                                                 longitude: 27.54912347929237,
                                                 categoryId: 0)
                
                self?.loadedOrganizations = [organization]
                
                completion?(true)
            },
            failure: { _ in
                
                let organization = CompanyEntity(title: "title",
                                                 descriptionText: "description",
                                                 directorFirstName: "name",
                                                 directorSecondName: "second name",
                                                 directorLastName: "last name",
                                                 locationCountry: "country",
                                                 locationCity: "city",
                                                 locationStreet: "street",
                                                 locationHomeNumber: "10",
                                                 contactsPhone: "12312",
                                                 contactsVK: "vk",
                                                 contactsWebSite: "web",
                                                 latitude: 53.90898898436514,
                                                 longitude: 27.54912347929237,
                                                 categoryId: 0)
                
                self.loadedOrganizations = [organization]
                
                completion?(true)
            }
        )
    }
    
    var organizations: [CompanyEntity] {
        
        return self.loadedOrganizations
            .filter {
                
                self.selectedCategories
                    .map { $0.rawValue }
                    .contains($0.categoryId)
            }
            .filter {
                
                if let search = self.searchText, search != "" {
                
                    return $0.title.lowercased().contains(search.lowercased())
                }
                else {
                    
                    return true
                }
            }
    }
}

// MARK: - CLLocationManagerDelegate

extension CompaniesSearchInteractor: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            self.userLocation = (latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
