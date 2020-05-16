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
    case putCoupon(String, String, Int, Int, String, String)
    case putTask(String, String, Int, Int, String, String)
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
        case .putCoupon(_, _, _, _, _, _):
            return "/putCoupon"
        case .putTask(_, _, _, _, _, _):
            return "/putTask"
        }
    }

    var method: Moya.Method {
        switch self {
        case .resolveTask(_, _, _):
            return .post
        case .activateCoupon(_, _, _):
            return .post
        case .putCoupon(_, _, _, _, _, _):
            return .put
        case .putTask(_, _, _, _, _, _):
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
        case .putTask(let name, let descriptionText, let count, let type, let token, let organizationName):
            return .requestParameters(
                parameters: [
                    "description": descriptionText,
                    "organizationName": organizationName,
                    "typeId": type + 1,
                    "token": token,
                    "count": count,
                    "name": name
                ],
                encoding: JSONEncoding.default
            )
        case .putCoupon(let name, let descriptionText, let count, let type, let token, let organizationName):
            return .requestParameters(
                parameters: [
                    "description": descriptionText,
                    "organizationName": organizationName,
                    "typeId": type + 1,
                    "token": token,
                    "count": count,
                    "name": name
                ],
                encoding: JSONEncoding.default
            )

        }
    }

    var headers: [String : String]? {
        return nil
    }
}
