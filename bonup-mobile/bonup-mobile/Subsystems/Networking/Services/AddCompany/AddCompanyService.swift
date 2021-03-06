//
//  AddCompanyService.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 3.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation
import Moya

enum AddCompanyService {
    
    case addCompany(token: String, companyEntity: CompanyEntity)
    case modifyCompany(token: String, companyEntity: CompanyEntity)
}

extension AddCompanyService: IMainTargetType {

    var baseURL: URL {
        return URL(string: SERVER_BASE_URL)!
    }

    var path: String {
        switch self {
        case .addCompany(_, _):
            return "/newOrganization"
        case .modifyCompany(_, _):
            return "/modifyOrganization"
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
        case .addCompany(let token, let entity), .modifyCompany(let token, let entity):
            
            return .requestParameters(
                parameters: [
                    "token": token,
                    "title": entity.title,
                    "descriptionText": entity.descriptionText,
                    "directorFirstName": entity.directorFirstName,
                    "directorSecondName": entity.directorSecondName,
                    "directorLastName": entity.directorLastName,
                    "address": entity.address,
                    "contactsPhone": entity.contactsPhone,
                    "contactsVK": entity.contactsVK,
                    "contactsWebSite": entity.contactsWebSite,
                    "categoryId": entity.categoryId,
                    "availableTasksCount": entity.availableTasksCount,
                    "availableCouponsCount": entity.availableCouponsCount,
                    "availableStocksCount": entity.availableStocksCount,
                    "photoId": entity.photoId,
                    "latitude": entity.latitude,
                    "longitude": entity.longitude
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
}
