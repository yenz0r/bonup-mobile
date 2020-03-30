//
//  NewPasswordService.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import Moya

struct NewPasswordParams {
    let newPassword: String
}

enum NewPasswordService {
    case setupNewPassword(params: NewPasswordParams)
}

extension NewPasswordService: IMainTargetType {

    var baseURL: URL {
        return URL(string: "server")!
    }

    var path: String {
        switch self {
        case .setupNewPassword(_):
            return ""
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
        case .setupNewPassword(let params):
            return .requestParameters(
                parameters: [
                    "newPassword": params.newPassword
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
