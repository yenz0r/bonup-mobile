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
    
    func loadOrganizations(withLoader: Bool, completion: ((Bool) -> Void)?)
}

final class CompaniesSearchInteractor: NSObject {

    // MARK: - Public variables
    
    var selectedCategories: [InterestCategories] = InterestCategories.allCases
    var userLocation: (latitude: Double, longitude: Double)?
    var searchText: String?
    
    // MARK: - Private variables
    
    private lazy var networkService = MainNetworkProvider<OrganizationsListService>()
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

    func loadOrganizations(withLoader: Bool, completion: ((Bool) -> Void)?) {
        
        guard let token = AccountManager.shared.currentToken else { completion?(false); return }
        
        _ = self.networkService.request(
            .getAllOrganizations(token),
            type: [CompanyEntity].self,
            withLoader: withLoader,
            completion: { [weak self] result in

                self?.loadedOrganizations = result
                
                completion?(true)
            },
            failure: { err in
                
                completion?(false)
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
