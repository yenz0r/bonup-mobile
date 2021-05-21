//
//  MapSearchManager.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import YandexMapsMobile

class MapSearchManager {
    
    private let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    private var searchSession: YMKSearchSession?
    private let map = YMKMapView(frame: CGRect(origin: .zero, size: .init(width: 200, height: 200)))
    
    deinit {
        
        searchSession?.cancel()
    }
    
    func search(for query: String, completion: @escaping ([YMKPoint], Error?) -> Void) {
        
        searchSession?.cancel()
        
        searchSession = searchManager.submit(
            withText: query,
            geometry: YMKVisibleRegionUtils.toPolygon(with: map.mapWindow.map.visibleRegion),
            searchOptions: YMKSearchOptions(),
            responseHandler: { response, error in
                
                if let err = error {
                    
                    completion([], err)
                    return
                }
                
                guard let response = response else {
                    
                    completion([], nil)
                    return
                }
                
                var points = [YMKPoint]()
                
                for searchResult in response.collection.children {
                    
                    if let point = searchResult.obj?.geometry.first?.point {
                        
                        points.append(point)
                    }
                }
                
                completion(points, nil)
            }
        )
    }
}
