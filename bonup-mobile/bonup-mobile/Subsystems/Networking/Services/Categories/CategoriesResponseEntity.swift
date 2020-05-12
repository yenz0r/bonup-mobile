//
//  CategoriesResponseEntity.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct CategoryInfo: Codable {
    let message: String
    let isSuccess: Bool
    let map: [Int:String]
}
