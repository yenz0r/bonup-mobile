//
//  CompanyPacketPresenter.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyPacketPresenter: AnyObject {

    var packets: [CompanyPacketType] { get }
}

final class CompanyPacketPresenter {

    // MARK: - Private variables

    private weak var view: ICompanyPacketView?
    private let interactor: ICompanyPacketInteractor
    private let router: ICompanyPacketRouter

    // MARK: - Init

    init(view: ICompanyPacketView?, interactor: ICompanyPacketInteractor, router: ICompanyPacketRouter) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - ICompanyPacketPresenter

extension CompanyPacketPresenter: ICompanyPacketPresenter {

    var packets: [CompanyPacketType] {

        return self.interactor.packets
    }
}
