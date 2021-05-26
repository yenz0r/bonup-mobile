//
//  PhotoResponseEntity.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

struct PhotoResponseEntity: Decodable {
    
    let message: String
    let isSuccess: Bool
}
