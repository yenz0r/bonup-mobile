//
//  NewPasswordResponseEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 15.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct NewPasswordResponseEntity: Codable {
    let isSuccess: Bool
    let newToken: String
    let message: String
}
