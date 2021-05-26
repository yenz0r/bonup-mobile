//
//  SettingsParamsPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ISettingsParamsPresenter: AnyObject {

    func numberOfItems() -> Int
    func itemForRow(_ index: Int) -> SettingsParamsCellViewModel
    func handleItemSelection(_ index: Int)
}

final class SettingsParamsPresenter {

    // MARK: - Private variables

    private weak var view: ISettingsParamsView?
    private let interactor: ISettingsParamsInteractor
    private let router: ISettingsParamsRouter

    // MARK: - Init

    init(view: ISettingsParamsView?, interactor: ISettingsParamsInteractor, router: ISettingsParamsRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ISettingsParamsPresenter implementation

extension SettingsParamsPresenter: ISettingsParamsPresenter {

    func numberOfItems() -> Int {

        self.interactor.paramsList().count
    }

    func itemForRow(_ index: Int) -> SettingsParamsCellViewModel {

        let title = self.interactor.paramsList()[index]
        let isSelected = title == self.interactor.paramsList()[self.interactor.selectedItem()]

        return SettingsParamsCellViewModel(
            title: title,
            isSelected: isSelected
        )
    }

    func handleItemSelection(_ index: Int) {

        if (self.interactor.selectedItem() != index) {

            self.interactor.saveParam(at: index)
        }

        self.router.stop(nil)
    }
}
