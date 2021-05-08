//
//  SelectCategoriesDataSource.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

final class SelectCategoriesDataSource: SelectCategoriesContainerDataSource {

    enum SelectionMode {
        case single, multiple
    }
    
    // MARK: - Private variables

    private var categoriesModels: [SelectCategoriesCellModel]
    private var selectionMode: SelectionMode
    private var isChangable: Bool

    // MARK: - Initialization

    init(selectedCategories: [InterestCategories], selectionMode: SelectionMode, isChangable: Bool = true) {

        self.selectionMode = selectionMode
        self.isChangable = isChangable
        
        self.categoriesModels = InterestCategories.allCases.map {
            
            SelectCategoriesCellModel(
                title: $0.title,
                category: $0,
                isActive: selectedCategories.contains($0)
            )
        }
        
        if self.selectionMode == .single,
           let category = selectedCategories.first,
           let index = self.categoriesModels.firstIndex(where: { $0.category == category }) {
            
            self.categoriesModels[index].isActive = true
            
            for modelIndex in self.categoriesModels.indices {
                
                if modelIndex != index {
                    
                    self.categoriesModels[modelIndex].isActive = false
                }
            }
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

        guard self.isChangable else { return }
        
        if (self.selectionMode == .single) {
            
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
