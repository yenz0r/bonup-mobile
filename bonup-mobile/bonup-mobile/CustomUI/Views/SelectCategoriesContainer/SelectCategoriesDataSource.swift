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
    private var isSingleSelectionOnly: Bool

    // MARK: - Initialization

    init(isActiveByDefault: Bool, isSingleSelectionOnly: Bool = false, initCategory: InterestCategories? = nil) {

        self.isSingleSelectionOnly = isSingleSelectionOnly
        
        self.categoriesModels = InterestCategories.allCases.map {
            
            SelectCategoriesCellModel(
                title: $0.title,
                category: $0,
                isActive: isSingleSelectionOnly ? false : isActiveByDefault
            )
        }
        
        if isSingleSelectionOnly,
           let category = initCategory,
           let index = self.categoriesModels.firstIndex(where: { $0.category == category }) {
            
            self.categoriesModels[index].isActive = true
        }
    }

    // MARK: - SelectCategoriesContainerDataSource

    func numberOfCategoriesInSelectCategoriesContainer(_ container: SelectCategoriesContainer) -> Int {

        return self.categoriesModels.count
    }

    func selectCategoriesContainer(_ container: SelectCategoriesContainer, cellModelAt index: Int) -> SelectCategoriesCellModel {

        return self.categoriesModels[index]
    }

    func selectCategoriesContainer(_ container: SelectCategoriesContainer, didSelectCategoryAt index: Int) {

        if (isSingleSelectionOnly) {
            
            if let prevIndex = self.categoriesModels.firstIndex(where: { $0.isActive }) {
                
                self.categoriesModels[prevIndex].isActive = false
            }
            
            self.categoriesModels[index].isActive = true
        }
        else {
        
            self.categoriesModels[index].isActive.toggle()
        }
    }

    var selectedCategories: [InterestCategories] {

        return self.categoriesModels
            .filter { $0.isActive }
            .map { $0.category }
    }
}
