//
//  SelectCategoriesDataSource.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

final class SelectCategoriesDataSource: SelectCategoriesContainerDataSource {

    // MARK: - Private variables

    private var categoriesModels: [SelectCategoriesCellModel]

    // MARK: - Initialization

    init(isActiveByDefault: Bool) {

        self.categoriesModels = InterestCategories.allCases.map { SelectCategoriesCellModel(title: $0.title,
                                                                                            category: $0,
                                                                                            isActive: isActiveByDefault) }
    }

    // MARK: - SelectCategoriesContainerDataSource

    func numberOfCategoriesInSelectCategoriesContainer(_ container: SelectCategoriesContainer) -> Int {

        return self.categoriesModels.count
    }

    func selectCategoriesContainer(_ container: SelectCategoriesContainer, cellModelAt index: Int) -> SelectCategoriesCellModel {

        return self.categoriesModels[index]
    }

    func selectCategoriesContainer(_ container: SelectCategoriesContainer, didSelectCategoryAt index: Int) {

        self.categoriesModels[index].isActive.toggle()
    }

    var selectedCategories: [InterestCategories] {

        return self.categoriesModels
            .filter { $0.isActive }
            .map { $0.category }
    }
}
