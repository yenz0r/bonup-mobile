//
//  OrganizationsListPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IOrganizationsListPresenter: AnyObject {

}

final class OrganizationsListPresenter {

    private weak var view: IOrganizationsListView?
    private let interactor: IOrganizationsListInteractor
    private let router: IOrganizationsListRouter

    init(view: IOrganizationsListView?, interactor: IOrganizationsListInteractor, router: IOrganizationsListRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IBenefitsPresenter implementation

extension OrganizationsListPresenter: IOrganizationsListPresenter {

}
