//
//  CategoriesService.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import Moya

enum CategoriesService {
    case sendSelectedCategories(token: String, selectedIds: [Int])
}

extension CategoriesService: IMainTargetType {

    var baseURL: URL {
        return URL(string: SERVER_BASE_URL)!
    }

    var path: String {
        switch self {
        case .sendSelectedCategories(_, _):
            return "/setCategories"
        }
    }

    var method: Moya.Method {
        switch self {
        case .sendSelectedCategories(_, _):
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .sendSelectedCategories(let token, let selectedIds):
            return .requestParameters(
                parameters: [
                    "token": token,
                    "ids": selectedIds
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
}
