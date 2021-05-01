//
//  OrganizationControlConstants.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 1.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

enum OrganizationControlAction {
    
    case verifyTask
    case varifyCoupon
    case addTask
    case addCoupon
    case statistics
    
    var title: String {
        
        switch self {
        case .verifyTask:
            return "ui_check_task"
            
        case .varifyCoupon:
            return "ui_check_benefit"
            
        case .addTask:
            return "ui_add_task"
            
        case .addCoupon:
            return "ui_add_benefit"
            
        case .statistics:
            return "ui_organization_statistics"
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
        }
    }
}
