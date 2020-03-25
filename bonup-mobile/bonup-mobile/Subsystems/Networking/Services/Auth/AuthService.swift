//
//  AuthService.swift
//  bonup-mobile
//
//  Created by yenz0redd on 15.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import Moya

struct AuthParams {
    let name: String
    let email: String
    let password: String
}

enum AuthService {
    case register(params: AuthParams)
    case auth(params: AuthParams)
}

extension AuthService: IMainTargetType {

    var baseURL: URL {
        return URL(string: "server")!
    }

    var path: String {
        switch self {
        case .auth(_):
            return "/auth"
        case .register(_):
            return "/register"
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
        case .auth(let params):
            return .requestParameters(
                parameters: [
                    "name": params.name,
                    "email": params.email,
                    "password": params.password
                ],
                encoding: JSONEncoding.default
            )
        case .register(let params):
            return .requestParameters(
                parameters: [
                    "name": params.name,
                    "email": params.email,
                    "password": params.password
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
