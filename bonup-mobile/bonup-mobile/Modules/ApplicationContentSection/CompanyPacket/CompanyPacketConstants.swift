//
//  CompanyPacketConstants.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

enum CompanyPacketType {

    case junior, middle, senior, custom(tasksCount: Int, benefitsCount: Int, price: Float)

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
        case .custom(_, _, _):
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
        case .custom(_, _, _):
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
        case .custom(_, _, _):
            return nil
        }
    }

    var color: UIColor {

        switch self {
        case .junior:
            return .green
        case .middle:
            return .orange
        case .senior:
            return .red
        case .custom(_, _, _):
            return .blue
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
        }
    }
}
