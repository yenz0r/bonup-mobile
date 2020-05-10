//
//  BenefitDescriptionInteractor.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 10.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IBenefitDescriptionInteractor: AnyObject {
    var codeLine: String { get }
    var benefitTitle: String { get }
    var benefitDescription: String { get }
}

final class BenefitDescriptionInteractor {

    // MARK: - Private variables

    private let benefitEntity: BenefitsResponseEntity

    // MARK: - Initialization

    init(benefitEntity: BenefitsResponseEntity) {

        self.benefitEntity = benefitEntity
    }
}

// MARK: - IChangePasswordInteractor implementation

extension BenefitDescriptionInteractor: IBenefitDescriptionInteractor {

    var benefitTitle: String {

        return self.benefitEntity.title ?? "ui_empty_title".localized
    }

    var benefitDescription: String {

        return self.benefitEntity.descriptionText ?? "ui_description_title".localized
    }

    var codeLine: String {

        guard
            let id = self.benefitEntity.id,
            let userToken = AccountManager.shared.currentToken
        else {

            return ""
        }

        return "\(id) - \(userToken)"
    }
}
