//
//  CategoriesPresenter.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol ICategoriesPresenter {
    
    var categories: [CategoriesPresentationModel] { get }

    func handleSkipButtonTap()
    func handleDoneButtonTap()
    func handleCardSwipe(at index: Int, isLike: Bool)
}

final class CategoriesPresenter {
    
    // MARK: - Private variables
    
    private weak var view: ICategoriesView?
    private let interactor: ICategoriesInteractor
    private let router: ICategoriesRouter

    // MARK: - Init
    
    init(view: ICategoriesView?, interactor: ICategoriesInteractor, router: ICategoriesRouter) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICategoriesPresenter implementation

extension CategoriesPresenter: ICategoriesPresenter {

    var categories: [CategoriesPresentationModel] {
        
        return self.interactor.allCategories.map {
            CategoriesPresentationModel(title: $0.title.localized,
                                        description: $0.description.localized)
        }
    }
    
    func handleDoneButtonTap() {
        
        self.saveChanges()
    }

    func handleSkipButtonTap() {
        
        self.saveChanges()
    }

    func handleCardSwipe(at index: Int, isLike: Bool) {
        
        if isLike {
        
            self.interactor.selectedCategories.append(self.interactor.allCategories[index])
        }

        if index == self.interactor.allCategories.count - 1 {
            
            self.saveChanges()
        }
    }
    
    private func saveChanges() {
        
        if self.interactor.selectedCategories.isEmpty {
            
            self.interactor.selectedCategories = self.interactor.allCategories
        }
        
        self.interactor.saveSeletedCategoriesRequest { [weak self] in
        
            guard let target = self?.interactor.target else { return }
            
            switch target {
            
            case .settings:
                self?.router.stop(nil)
                
            case .login:
                self?.router.show(.openApplication)
            }
        }
    }
}
