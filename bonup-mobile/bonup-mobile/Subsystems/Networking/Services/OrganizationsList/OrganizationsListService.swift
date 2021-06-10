//
//  OrganizationsList.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

import Moya

enum OrganizationsListService {
    case getOrganizations(String)
    case getAllOrganizations(String)
}

extension OrganizationsListService: IAuthorizedTargetType {

    var baseURL: URL {
        return URL(string: SERVER_BASE_URL)!
    }

    var path: String {
        switch self {
        
        case .getOrganizations(_):
            return "/userOrganizations"
            
        case .getAllOrganizations(_):
            return "/allOrganizations"
        }
    }

    var method: Moya.Method {
        switch self {
        
        case .getOrganizations(_):
            return .post
            
        case .getAllOrganizations(_):
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        
        case .getOrganizations(let token),
             .getAllOrganizations(let token):
            return .requestParameters(
                parameters: [
                    "token": token
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
