//
//  CompanyCustomPacketInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol ICompanyCustomPacketInteractor: AnyObject {

    var tasksCount: Int { get set }
    var benefitsCount: Int { get set }
    var price: Float { get }
}

final class CompanyCustomPacketInteractor {

    // MARK: - Private variables

    private var _tasksCount: Int = 0
    private var _benefitsCount: Int = 0
}

// MARK: - ICompanyPacketInteractor implementation

extension CompanyCustomPacketInteractor: ICompanyCustomPacketInteractor {

    var tasksCount: Int {

        get {

            return self._tasksCount
        }

        set {

            self._tasksCount = newValue
        }
    }

    var benefitsCount: Int {

        get {

            return self._benefitsCount
        }

        set {

            self._benefitsCount = newValue
        }
    }

    var price: Float {

        return Float(self._tasksCount) * 1.9 + Float(self._benefitsCount) * 0.9
    }
}
