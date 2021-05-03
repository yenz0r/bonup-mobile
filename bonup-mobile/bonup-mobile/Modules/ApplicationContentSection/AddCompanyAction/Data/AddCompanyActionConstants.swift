//
//  AddCompanyActionConstants.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 25.04.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

enum CompanyActionType {
    
    case task
    case coupon
    
    var title: String {
        
        switch self {
        
        case .task:
            return "ui_company_add_task"
            
        case .coupon:
            return "ui_company_add_coupon"
        }
    }
}

enum CompanyActionFieldType {
    
    case title
    case description
    case startDate
    case endDate
    case bonuses
    case allowedCount
    
    var title: String {
        
        switch self {
        case .title:
            return "ui_title_label"
            
        case .description:
            return "ui_description_label"
            
        case .startDate:
            return "ui_start_date_label"
            
        case .endDate:
            return "ui_end_date_label"
            
        case .bonuses:
            return "ui_bonuses_count_label"
            
        case .allowedCount:
            return "ui_allowed_count_label"
        }
    }
}
