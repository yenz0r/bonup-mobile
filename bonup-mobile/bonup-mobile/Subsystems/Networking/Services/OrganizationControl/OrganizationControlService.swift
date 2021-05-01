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
    case putCoupon(OrganizationControlAppendRequestEntity)
    case putTask(OrganizationControlAppendRequestEntity)
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
        case .putCoupon(_):
            return "/putCoupon"
        case .putTask(_):
            return "/putTask"
        }
    }

    var method: Moya.Method {
        switch self {
        case .resolveTask(_, _, _):
            return .post
        case .activateCoupon(_, _, _):
            return .post
        case .putCoupon(_):
            return .put
        case .putTask(_):
            return .put
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
        case .putTask(let entity):
            fallthrough
        case .putCoupon(let entity):
            return .requestParameters(
                parameters: [
                    "description": entity.descriptionText,
                    "organizationName": entity.organizationId,
                    "typeId": 1,
                    "token": entity.token,
                    "count": entity.bonusesCount,
                    "name": entity.title
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
