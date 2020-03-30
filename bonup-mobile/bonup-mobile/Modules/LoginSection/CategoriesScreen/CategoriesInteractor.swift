//
//  CategoriesInteractor.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol ICategoriesInteractor: AnyObject {
    func categotiesListRequest(location: String,
                               success: (([CategoryInfo]) -> Void)?,
                               failure: (() -> Void)?)
}

final class CategoriesInteractor {

    // MARK: - Private variables

    private let networkProvider = MainNetworkProvider<CategoriesService>()

}

// MAKR: - IAuthVerificationInteractor implemenetation

extension CategoriesInteractor: ICategoriesInteractor {

    func categotiesListRequest(location: String,
                               success: (([CategoryInfo]) -> Void)?,
                               failure: (() -> Void)?) {

        let categoriesParams = CategoriesParams(location: location)

        _ = networkProvider.request(
            .askCategories(params: categoriesParams),
            type: CategoriesResponseEntity.self,
            completion: { result in
                success?(result.categoryInfoList)
            },
            failure: { _ in
                failure?()
            }
        )
    }
    
}
