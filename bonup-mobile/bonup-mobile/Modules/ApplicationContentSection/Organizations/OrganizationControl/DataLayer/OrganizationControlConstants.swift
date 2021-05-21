//
//  OrganizationControlConstants.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 1.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

enum OrganizationControlAction: Int, CaseIterable {
    
    case verifyTask = 0
    case varifyCoupon
    case addTask
    case addCoupon
    case addStock
    case actionsList
    case statistics
    case modifyInfo
    
    var title: String {
        
        switch self {
        case .verifyTask:
            return "ui_check_task"
            
        case .varifyCoupon:
            return "ui_check_benefit"
            
        case .addTask:
            return "ui_company_add_task"
            
        case .addCoupon:
            return "ui_company_add_coupon"
            
        case .statistics:
            return "ui_organization_statistics"
            
        case .modifyInfo:
            return "ui_company_modify"
            
        case .addStock:
            return "ui_company_add_stock"
            
        case .actionsList:
            return "ui_company_actions_list"
        }
    }
    
    var icon: UIImage? {
        
        switch self {
        
        case .verifyTask:
            return AssetsHelper.shared.image(.settingsRateUs)
            
        case .varifyCoupon:
            return AssetsHelper.shared.image(.settingsHelp)
            
        case .addTask:
            return AssetsHelper.shared.image(.settingsCategory)
            
        case .addCoupon:
            return AssetsHelper.shared.image(.settingsRateUs)
            
        case .statistics:
            return AssetsHelper.shared.image(.settingsCategory)
            
        case .modifyInfo:
            return AssetsHelper.shared.image(.settingsCategory)
            
        case .addStock:
            return AssetsHelper.shared.image(.settingsCategory)
            
        case .actionsList:
            return AssetsHelper.shared.image(.settingsCategory)
        }
    }
}
