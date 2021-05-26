//
//  ProfileService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

import Moya

enum ProfileService {

    case getUsetData(String)
}

extension ProfileService: IAuthorizedTargetType {

    var baseURL: URL {
        return URL(string: SERVER_BASE_URL)!
    }

    var path: String {
        switch self {
        case .getUsetData(_):
            return "/userInfo"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getUsetData(_):
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case .getUsetData(let token):
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
