//
//  AuthVerificationService.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import Moya

struct EmailVerificationParams {
    let code: String
}

enum EmailVerificationService {
    case verify(params: EmailVerificationParams)
    case resend
}

extension EmailVerificationService: IMainTargetType {

    var baseURL: URL {
        return URL(string: serverBase)!
    }

    var path: String {
        switch self {
        case .resend:
            return "/resend"
        case .verify(_):
            return "/verifyMail"
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
                    "email": AccountManager.shared.currentUser?.email ?? "",
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
