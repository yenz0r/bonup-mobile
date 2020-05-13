//
//  OrganizationControlService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

import Moya

enum OrganizationControlService {

    case resolveTask(Int, String, String)
    case activateCoupon(Int, String, String)
}

extension OrganizationControlService: IAuthorizedTargetType {

    var baseURL: URL {
        return URL(string: serverBase)!
    }

    var path: String {
        switch self {
        case .resolveTask(_, _, _):
            return "/resolveTask"
        case .activateCoupon(_, _, _):
            return "/activateCoupon"
        }
    }

    var method: Moya.Method {
        switch self {
        case .resolveTask(_, _, _):
            return .post
        case .activateCoupon(_, _, _):
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case .activateCoupon(let id, let userToken, let orgToken):
            return .requestParameters(
                parameters: [
                    "id": id,
                    "userToken": userToken,
                    "employeeToken": orgToken
                ],
                encoding: JSONEncoding.default
            )
        case .resolveTask(let id, let userToken, let orgToken):
            return .requestParameters(
                parameters: [
                    "id": id,
                    "userToken": userToken,
                    "employeeToken": orgToken
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
