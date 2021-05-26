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

    var allCategories: [InterestCategories] { get }
    var selectedCategories: [InterestCategories] { get set }
    var target: CategoriesDependency.Target { get }
    
    func saveSeletedCategoriesRequest(completion: @escaping () -> Void)
}

final class CategoriesInteractor {

    // MARK: - Private variables

    private lazy var networkProvider = MainNetworkProvider<CategoriesService>()
    
    // MARK: - Public variables
    
    var allCategories: [InterestCategories] = InterestCategories.allCases
    var selectedCategories: [InterestCategories] = []
    var target: CategoriesDependency.Target
    
    // MARK: - Init
    
    init(target: CategoriesDependency.Target) {
        
        self.target = target
    }
}

// MAKR: - IAuthVerificationInteractor implemenetation

extension CategoriesInteractor: ICategoriesInteractor {

    func saveSeletedCategoriesRequest(completion: @escaping () -> Void) {

        guard let token = AccountManager.shared.currentToken else { return }
        
        _ = networkProvider.request(
            .sendSelectedCategories(token: token,
                                    selectedIds: self.selectedCategories.map { $0.rawValue }),
            type: DefaultResponseEntity.self,
            completion: { result in
                
                completion()
                
            },
            failure: { _ in })
    }
}
