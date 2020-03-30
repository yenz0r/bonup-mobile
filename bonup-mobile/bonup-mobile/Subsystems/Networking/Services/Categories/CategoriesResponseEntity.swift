//
//  CategoriesResponseEntity.swift
//  bonup-mobile
//
//  Created by yenz0redd on 28.03.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation

struct CategoryInfo: Codable {
    let name: String
    let imageUrl: String
}

struct CategoriesResponseEntity: Codable {
    let categoryInfoList: [CategoryInfo]
}
