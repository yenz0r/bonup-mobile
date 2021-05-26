//
//  TaskSelectionService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import Moya

enum TaskSelectionService {
    case getTasks(String)
    case saveTasks(String, [Int])
}

extension TaskSelectionService: IAuthorizedTargetType {

    var baseURL: URL {
        return URL(string: SERVER_BASE_URL)!
    }

    var path: String {
        switch self {
        case .getTasks(_):
            return "/tasksCatalog"
        case .saveTasks(_, _):
            return "/acceptTasks"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getTasks(_):
            return .post
        case .saveTasks(_, _):
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getTasks(let token):
            return .requestParameters(
                parameters: [
                    "token": token
                ],
                encoding: JSONEncoding.default
            )
        case .saveTasks(let token, let ids):
            return .requestParameters(
                parameters: [
                    "token": token,
                    "ids": ids
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
