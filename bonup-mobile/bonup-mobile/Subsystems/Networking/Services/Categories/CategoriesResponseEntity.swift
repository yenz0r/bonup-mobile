//
//  CategoriesResponseEntity.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct CategoryInfo: Codable {
    let id: Int
    let name: String
    let description: String
}

struct CategoriesResponseEntity: Codable {
    let categoryInfoList: [CategoryInfo]
}
