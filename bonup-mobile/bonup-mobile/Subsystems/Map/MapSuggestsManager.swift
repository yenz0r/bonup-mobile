//
//  MapSuggestsManager.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 21.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import YandexMapsMobile

class MapSuggestsManager {
    
    private lazy var searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
    private lazy var suggestSession = self.searchManager.createSuggestSession()
    
    private let BOUNDING_BOX = YMKBoundingBox(
        southWest: YMKPoint(latitude: 55.55, longitude: 37.42),
        northEast: YMKPoint(latitude: 55.95, longitude: 37.82))
    private let SUGGEST_OPTIONS = YMKSuggestOptions()
    
    deinit {
        
        self.suggestSession.reset()
    }
    
    func suggests(for query: String, completion: @escaping ([YMKSuggestItem]?, Error?) -> Void) {
        
        self.suggestSession.suggest(
            withText: query,
            window: BOUNDING_BOX,
            suggestOptions: SUGGEST_OPTIONS,
            responseHandler: completion)
    }
}
