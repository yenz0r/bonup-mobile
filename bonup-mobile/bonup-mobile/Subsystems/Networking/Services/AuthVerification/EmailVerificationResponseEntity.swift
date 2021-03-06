//
//  AuthVerificationResponseEntity.swift
//  bonup-mobile
//
//  Created by yenz0redd on 25.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct EmailVerificationResponseEntity: Decodable {
    let token: String
    let isSuccess: Bool
    let message: String
}
