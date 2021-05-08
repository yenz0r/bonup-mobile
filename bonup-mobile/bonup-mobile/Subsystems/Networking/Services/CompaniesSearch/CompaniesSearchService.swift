//
//  CompaniesSearchService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 7.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import Moya

enum CompaniesSearchService {
    
    case loadCompanies(token: String)
}

extension CompaniesSearchService: IMainTargetType {

    var baseURL: URL {
        return URL(string: serverBase)!
    }

    var path: String {
        switch self {
        case .loadCompanies(_):
            return "/companies"
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
        case .loadCompanies(let token):
            return .requestParameters(
                parameters: [
                    "token": token
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
}
