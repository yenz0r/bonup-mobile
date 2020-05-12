//
//  CategoriesInteractor.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct CategoryInfoEntity {
    let id: Int
    let name: String
    let description: String
}

protocol ICategoriesInteractor: AnyObject {
    func categotiesListRequest(success: (([CategoryInfoEntity]) -> Void)?,
                               failure: (() -> Void)?)
    func saveSeletedCategoriesRequest(selectedIds: [Int])
}

final class CategoriesInteractor {

    // MARK: - Private variables

    private let networkProvider = MainNetworkProvider<CategoriesService>()

}

// MAKR: - IAuthVerificationInteractor implemenetation

extension CategoriesInteractor: ICategoriesInteractor {

    func categotiesListRequest(success: (([CategoryInfoEntity]) -> Void)?,
                               failure: (() -> Void)?) {

        _ = networkProvider.request(
            .askCategories,
            type: CategoryInfo.self,
            completion: { result in

                if result.isSuccess {

                    var resultArray = [CategoryInfoEntity]()
                    let keys = result.map.keys
                    for key in keys {

                        let info = result.map[key] ?? ""
                        let entity = CategoryInfoEntity(id: key, name: info, description: "For everyone who are interested in sport and healthy life style")
                        resultArray.append(entity)
                    }

                    success?(resultArray)

                } else {

                    failure?()
                }
            },
            failure: { _ in

                failure?()
            }
        )
    }

    func saveSeletedCategoriesRequest(selectedIds: [Int]) {

        _ = networkProvider.requestSignal(.sendSelectedCategories(selectedIds: selectedIds))

    }
    
}
