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
            return "ui_food_category".localized
        case .sport:
            return "ui_sport_category".localized
        case .media:
            return "ui_media_category".localized
        case .health:
            return "ui_health_category".localized
        case .literature:
            return "ui_literature_category".localized
        case .films:
            return "ui_films_category".localized
        case .music:
            return "ui_music_category".localized
        case .coffe:
            return "ui_coffe_category".localized
        case .services:
            return "ui_services_category".localized
        }
    }
}
