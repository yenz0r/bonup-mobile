//
//  OrganizationActionsService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 18.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Moya

enum OrganizationActionsService {
    case getTasks(token: String, companyName: String)
    case getCoupons(token: String, companyName: String)
    case getStocks(token: String, companyName: String)
}

extension OrganizationActionsService: IAuthorizedTargetType {

    var baseURL: URL {
        return URL(string: serverBase)!
    }

    var path: String {
        switch self {
        case .getTasks(_, _):
            return "/userOrganizations"
            
        case .getCoupons(_, _):
            return "/userOrganizations"
            
        case .getStocks(_, _):
            return "/userOrganizations"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getTasks(_, _):
            return .get
            
        case .getCoupons(_, _):
            return .get
            
        case .getStocks(_, _):
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getTasks(let token, let companyName),
             .getCoupons(let token, let companyName),
             .getStocks(let token, let companyName):
            
            return .requestParameters(
                parameters: [
                    "token": token,
                    "companyName": companyName
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}

