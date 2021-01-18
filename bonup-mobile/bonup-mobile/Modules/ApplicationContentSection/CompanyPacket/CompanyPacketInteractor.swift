//
//  CompanyPacketInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyPacketInteractor: AnyObject {

    var packets: [CompanyPacketType] { get }
}

final class CompanyPacketInteractor {

    // MARK: - Initialization

    init() {

        self._packets = CompanyPacketType.allCases
    }

    // MARK: - Private variables

    private var _packets: [CompanyPacketType]
}

// MARK: - ICompanyPacketInteractor implementation

extension CompanyPacketInteractor: ICompanyPacketInteractor {

    var packets: [CompanyPacketType] {

        return self._packets
    }
}
