//
//  SelectCategoriesConstants.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 17.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

enum InterestCategories: Int, CaseIterable {

    case food = 50
    case sport
    case media
    case health
    case literature
    case films
    case music
    case coffe
    case services
    
    static func category(id: Int) -> InterestCategories {
        
        return InterestCategories(rawValue: id) ?? .food
    }

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
    
    var description: String {

        switch self {
        
        case .food:
            return "ui_food_category_description"
            
        case .sport:
            return "ui_sport_category_description"
            
        case .media:
            return "ui_media_category_description"
            
        case .health:
            return "ui_health_category_description"
            
        case .literature:
            return "ui_literature_category_description"
            
        case .films:
            return "ui_films_category_description"
            
        case .music:
            return "ui_music_category_description"
            
        case .coffe:
            return "ui_coffe_category_description"
            
        case .services:
            return "ui_services_category_description"
        }
    }
    
    var color: UIColor {
        
        switch self {
        
        case .food:
            return .init(hex: "#E37C55")
            
        case .sport:
            return .init(hex: "#D36157")
            
        case .media:
            return .init(hex: "#F1B355")
            
        case .health:
            return .init(hex: "#FF7B94")
            
        case .literature:
            return .init(hex: "#7E707D")
            
        case .films:
            return .init(hex: "#B1C3DF")
            
        case .music:
            return .init(hex: "#F2E4E4")
            
        case .coffe:
            return .init(hex: "#B0EBE1")
            
        case .services:
            return .init(hex: "#A0DDFA")
        }
    }
}
