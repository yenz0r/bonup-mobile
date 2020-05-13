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
    var benefitImageLink: String { get }
}

final class BenefitDescriptionInteractor {

    // MARK: - Private variables

    private let benefitEntity: ActualBenefitEntity

    // MARK: - Initialization

    init(benefitEntity: ActualBenefitEntity) {

        self.benefitEntity = benefitEntity
    }
}

// MARK: - IChangePasswordInteractor implementation

extension BenefitDescriptionInteractor: IBenefitDescriptionInteractor {

    var benefitTitle: String {

        return self.benefitEntity.name
    }

    var benefitDescription: String {

        return self.benefitEntity.description
    }

    var benefitImageLink: String {
        
        return self.benefitEntity.photos.first ?? ""
    }

    var codeLine: String {

        guard let userToken = AccountManager.shared.currentToken else {

            return ""
        }

        let id = self.benefitEntity.id

        return "\(id) - \(userToken)"
    }
}
