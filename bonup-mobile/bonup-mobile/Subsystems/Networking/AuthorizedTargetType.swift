//
//  AuthorizedTargetType.swift
//  bonup-mobile
//
//  Created by yenz0redd on 15.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

protocol IXPSAuthorizedTargetType: IMainTargetType {

}

extension IXPSAuthorizedTargetType {

    var requiredHeaders: [String: String]? {

        // auth tocken

        return ["Authorization" : "", //tocken
                "Content-Type" : "application/json"]
    }
}
