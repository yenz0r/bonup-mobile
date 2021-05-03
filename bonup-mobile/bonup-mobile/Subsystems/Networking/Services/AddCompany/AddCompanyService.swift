//
//  AddCompanyService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 3.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import Moya

enum AddCompanyService {
    
    case addCompany(token: String, companyEntity: AddCompanyRequestEntity)
}

extension AddCompanyService: IMainTargetType {

    var baseURL: URL {
        return URL(string: serverBase)!
    }

    var path: String {
        switch self {
        case .addCompany(_, _):
            return "/isUserExist"
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
        case .addCompany(_, _):
            return .requestParameters(
                parameters: [
                    "email": "params.email"
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
}

