//
//  OrganizationsListPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 11.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import UIKit

protocol IOrganizationsListPresenter: AnyObject {

    func viewWillAppear()
    func title(for index: Int) -> String
    func imagePath(for index: Int) -> String
    func numberOfOrganizations() -> Int
    func handleShowOgranizationControl(for index: Int)

    func handleAddButtonTap()
}

final class OrganizationsListPresenter {

    private weak var view: IOrganizationsListView?
    private let interactor: IOrganizationsListInteractor
    private let router: IOrganizationsListRouter

    private var organizationsResponse: OrganizationsListResponseEntity?

    init(view: IOrganizationsListView?, interactor: IOrganizationsListInteractor, router: IOrganizationsListRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IBenefitsPresenter implementation

extension OrganizationsListPresenter: IOrganizationsListPresenter {
    func title(for index: Int) -> String {

        guard let response = self.organizationsResponse else { return "-" }

        return response.organizations[index].name
    }

    func imagePath(for index: Int) -> String {

        guard let response = self.organizationsResponse else { return "" }

        return response.organizations[index].photo
    }

    func handleShowOgranizationControl(for index: Int) {

        guard let response = self.organizationsResponse else { return }

        self.router.show(.showOrganizationControl(response.organizations[index].name))
    }

    func numberOfOrganizations() -> Int {

        guard let response = self.organizationsResponse else { return 0 }

        return response.organizations.count
    }

    func viewWillAppear() {

        self.interactor.getOrganizationsList(
            success: { [weak self] entity in

                self?.organizationsResponse = entity
                self?.view?.reloadData()
            }, failure: { status, message in

                print("---")
            }
        )
    }

    func handleAddButtonTap() {

        self.router.show(.showAddNewOrganization)
    }
}
