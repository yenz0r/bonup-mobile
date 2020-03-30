//
//  ResetPassword.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import Moya

struct ResetPasswordParams {
    let email: String
}

enum ResetPasswordService {
    case askResetCode(params: ResetPasswordParams)
}

extension ResetPasswordService: IMainTargetType {

    var baseURL: URL {
        return URL(string: "server")!
    }

    var path: String {
        switch self {
        case .askResetCode(_):
            return "/reset"
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
        case .askResetCode(let params):
            return .requestParameters(
                parameters: [
                    "email": params.email
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
