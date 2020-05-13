//
//  AuthorizedTargetType.swift
//  bonup-mobile
//
//  Created by yenz0redd on 15.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IAuthorizedTargetType: IMainTargetType {

}

extension IAuthorizedTargetType {
    var requiredHeaders: [String: String]? {

        return ["Content-Type" : "application/json"]
    }
}
