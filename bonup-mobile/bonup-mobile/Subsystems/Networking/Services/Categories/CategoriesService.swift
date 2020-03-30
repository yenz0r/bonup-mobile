//
//  CategoriesService.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import Moya

struct CategoriesParams {
    let location: String
}

enum CategoriesService {
    case askCategories(params: CategoriesParams)
}

extension CategoriesService: IMainTargetType {

    var baseURL: URL {
        return URL(string: "server")!
    }

    var path: String {
        switch self {
        case .askCategories(_):
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
        case .askCategories(let params):
            return .requestParameters(
                parameters: [
                    "location": params.location
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}

