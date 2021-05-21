//
//  CompanyStatisticsService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 19.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Moya

enum CompanyStatisticsService {

    case getStatistics(String, String)
}

extension CompanyStatisticsService: IAuthorizedTargetType {

    var baseURL: URL {
        return URL(string: SERVER_BASE_URL)!
    }

    var path: String {
        switch self {
        case .getStatistics(_, _):
            return "/organizationTasksAndCoupons"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getStatistics(_, _):
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case .getStatistics(let token, let companyName):
            return .requestParameters(
                parameters: [
                    "token": token,
                    "name": companyName
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
