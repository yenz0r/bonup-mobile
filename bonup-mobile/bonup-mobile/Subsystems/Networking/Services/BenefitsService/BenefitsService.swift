//
//  BenefitsService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

import Moya

enum BenefitsService {

    case buyCoupon(Int, String)
    case myCoupons(String)
}

extension BenefitsService: IAuthorizedTargetType {

    var baseURL: URL {
        return URL(string: SERVER_BASE_URL)!
    }

    var path: String {
        switch self {
        case .buyCoupon(_, _):
            return "/buyCoupon"
        case .myCoupons(_):
            return "/userCoupons"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case .myCoupons(let token):
            return .requestParameters(
                parameters: [
                    "token": token
                ],
                encoding: JSONEncoding.default
            )
        case .buyCoupon(let id, let token):
            return .requestParameters(
                parameters: [
                    "token": token,
                    "id": id
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
