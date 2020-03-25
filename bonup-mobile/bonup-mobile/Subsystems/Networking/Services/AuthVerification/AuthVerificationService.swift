//
//  AuthVerificationService.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import Moya

struct AuthVerificationParams {
    let code: String
}

enum AuthVerificationService {
    case verify(params: AuthVerificationParams)
    case resend
}

extension AuthVerificationService: IMainTargetType {

    var baseURL: URL {
        return URL(string: "server")!
    }

    var path: String {
        switch self {
        case .resend:
            return "/resend"
        case .verify(_):
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
        case .verify(let params):
            return .requestParameters(
                parameters: [
                    "code": params.code
                ],
                encoding: JSONEncoding.default
            )
        case .resend:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
