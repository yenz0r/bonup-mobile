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
    case askCategories
    case sendSelectedCategories(selectedIds: [Int])
}

extension CategoriesService: IMainTargetType {

    var baseURL: URL {
        return URL(string: "server")!
    }

    var path: String {
        switch self {
        case .askCategories:
            return "/categoriesList"
        case .sendSelectedCategories(_):
            return "/saveSelectedCategories"
        }
    }

    var method: Moya.Method {
        switch self {
        case .askCategories:
            return .get
        case .sendSelectedCategories(_):
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .askCategories:
            return .requestPlain
        case .sendSelectedCategories(let selectedIds):
            return .requestParameters(
                parameters: [
                    "selectedIds": selectedIds
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}

