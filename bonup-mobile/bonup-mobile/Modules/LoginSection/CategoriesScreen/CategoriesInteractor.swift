//
//  CategoriesInteractor.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ICategoriesInteractor: AnyObject {
    func categotiesListRequest(success: (([CategoryInfo]) -> Void)?,
                               failure: (() -> Void)?)
    func saveSeletedCategoriesRequest(selectedIds: [Int])
}

final class CategoriesInteractor {

    // MARK: - Private variables

    private let networkProvider = MainNetworkProvider<CategoriesService>()

}

// MAKR: - IAuthVerificationInteractor implemenetation

extension CategoriesInteractor: ICategoriesInteractor {

    func categotiesListRequest(success: (([CategoryInfo]) -> Void)?,
                               failure: (() -> Void)?) {

        _ = networkProvider.request(
            .askCategories,
            type: CategoriesResponseEntity.self,
            completion: { result in
                //test
                let info = CategoryInfo(id: 0, name: "Sport", description: "For everyone who are interested in sport and healthy life style")

                success?(Array(repeating: info, count: 10))
            },
            failure: { _ in
                //failure?()

                let info = CategoryInfo(id: 0, name: "Sport", description: "For everyone who are interested in sport and healthy life style")

                success?(Array(repeating: info, count: 10))
            }
        )
    }

    func saveSeletedCategoriesRequest(selectedIds: [Int]) {

        _ = networkProvider.requestSignal(.sendSelectedCategories(selectedIds: selectedIds))

    }
    
}
