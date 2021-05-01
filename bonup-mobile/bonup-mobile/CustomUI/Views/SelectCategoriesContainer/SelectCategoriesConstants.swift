//
//  SelectCategoriesConstants.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

enum InterestCategories: Int, CaseIterable {

    case food = 0
    case sport
    case media
    case health
    case literature
    case films
    case music
    case coffe
    case services

    var title: String {

        switch self {
        case .food:
            return "ui_food_category"
        case .sport:
            return "ui_sport_category"
        case .media:
            return "ui_media_category"
        case .health:
            return "ui_health_category"
        case .literature:
            return "ui_literature_category"
        case .films:
            return "ui_films_category"
        case .music:
            return "ui_music_category"
        case .coffe:
            return "ui_coffe_category"
        case .services:
            return "ui_services_category"
        }
    }
}
