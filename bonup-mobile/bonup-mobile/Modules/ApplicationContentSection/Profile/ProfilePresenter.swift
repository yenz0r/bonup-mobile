//
//  ProfilePresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 20.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IProfilePresenter: AnyObject {
    func handleInfoButtonTapped()
}

final class ProfilePresenter {
    private weak var view: IProfileView?
    private let interactor: IProfileInteractor
    private let router: IProfileRouter

    init(view: IProfileView?, interactor: IProfileInteractor, router: IProfileRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ITaskSelectionPresenter implementation

extension ProfilePresenter: IProfilePresenter {
    func handleInfoButtonTapped() {
        self.router.show(.infoAlert)
    }

}

