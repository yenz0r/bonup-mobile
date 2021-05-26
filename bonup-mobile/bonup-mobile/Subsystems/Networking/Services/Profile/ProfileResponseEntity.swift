//
//  ProfileResponseEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.05.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct ProfileResponseEntity: Decodable {

    let isSuccess: Bool
    let message: String

    let userInfo: ProfileResponseDetailsEntity
}
