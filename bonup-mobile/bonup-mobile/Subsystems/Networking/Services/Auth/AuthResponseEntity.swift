//
//  AuthResponseEntity.swift
//  bonup-mobile
//
//  Created by yenz0redd on 15.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct AuthResponseEntity: Decodable {
    let message: String
    let status: Bool
}
