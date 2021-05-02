//
//  CompanyStatisticsConstants.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 2.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit

enum CompanyStatisticsPeriod: Int, CaseIterable {
    
    case week = 0, month, year
    
    var title: String {
        
        switch self {
        
        case .week:
            return "ui_period_week"
            
        case .month:
            return "ui_period_month"
            
        case .year:
            return "ui_period_year"
        }
    }
    
    var id: Int {
        
        return self.rawValue
    }
    
    var gradientForChart: CGGradient {
        
        var color: UIColor
        
        switch self {
        
        case .week:
            color = .cyan
            
        case .month:
            color = .purple
            
        case .year:
            color = .orange
        }
        
        let gradientColors = [color.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                               colors: gradientColors,
                               locations: colorLocations)!
    }
}
