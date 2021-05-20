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
    case putCoupon(String, OrganizationActionEntity)
    case putTask(String, OrganizationActionEntity)
    case putStock(String, OrganizationActionEntity)
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
        case .putCoupon(_, _):
            return "/newCoupon"
        case .putTask(_, _):
            return "/newTask"
        case .putStock(_, _):
            return "/newStock"
        }
    }

    var method: Moya.Method {
        switch self {
        case .resolveTask(_, _, _),
             .activateCoupon(_, _, _):
            return .post
            
        case .putCoupon(_, _),
             .putTask(_, _),
             .putStock(_, _):
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
        case .putTask(let token, let entity),
             .putCoupon(let token, let entity),
             .putStock(let token, let entity):
            
            return .requestParameters(
                parameters: [
                    "title": entity.title,
                    "descriptionText": entity.descriptionText,
                    "token": token,
                    "bonusesCount": entity.bonusesCount,
                    "categoryId": entity.categoryId,
                    "organizationName": entity.organizationName,
                    "startDateTimestamp": entity.startDateTimestamp,
                    "endDateTimestamp": entity.endDateTimestamp,
                    "allowedCount": entity.allowedCount,
                    "photoId": entity.photoId,
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
