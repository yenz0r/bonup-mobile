//
//  CompanyPacketConstants.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

enum CompanyPacketType {

    case junior, middle, senior, custom(tasksCount: Int, benefitsCount: Int, price: Float), none

    static var allCases: [CompanyPacketType] {

        return [.junior,
                .middle,
                .senior,
                .custom(tasksCount: 0, benefitsCount: 0, price: 0)]
    }

    var id: Int {

        switch self {
        case .junior:
            return 0
        case .middle:
            return 1
        case .senior:
            return 2
        case .custom(_, _, _):
            return 3
        case .none:
            return 4
        }
    }

    var title: String {

        switch self {
        case .junior:
            return "ui_company_packet_junior_title"
        case .middle:
            return "ui_company_packet_middle_title"
        case .senior:
            return "ui_company_packet_senior_title"
        case .custom(_, _, _):
            return "ui_company_packet_custom_title"
        case .none:
            return ""
        }
    }

    var tasksCount: Int? {

        switch self {
        case .junior:
            return 20
        case .middle:
            return 100
        case .senior:
            return 500
        case .custom(let tasksCount, _, _):
            return tasksCount
        case .none:
            return nil
        }
    }

    var benefitsCount: Int? {

        switch self {
        case .junior:
            return 5
        case .middle:
            return 20
        case .senior:
            return 50
        case .custom(_, let benefitsCount, _):
            return benefitsCount
        case .none:
            return nil
        }
    }

    var price: Float? {

        switch self {
        case .junior:
            return 5
        case .middle:
            return 10
        case .senior:
            return 50
        case .custom(_, _, let price):
            return price
        case .none:
            return nil
        }
    }

    var color: UIColor {

        switch self {
        case .junior:
            return .systemGreen
        case .middle:
            return .orange
        case .senior:
            return .systemRed
        case .custom(_, _, _):
            return .cyan
        case .none:
            return .black
        }
    }

    var icon: UIImage? {

        switch self {
        case .junior:
            return AssetsHelper.shared.image(.juniorPacketIcon)
        case .middle:
            return AssetsHelper.shared.image(.middlePacketIcon)
        case .senior:
            return AssetsHelper.shared.image(.seniorPacketIcon)
        case .custom(_, _, _):
            return AssetsHelper.shared.image(.customPacketIcon)
        case .none:
            return nil
        }
    }
}
