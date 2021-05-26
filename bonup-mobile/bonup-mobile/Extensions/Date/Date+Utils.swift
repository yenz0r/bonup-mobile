//
//  Date+Utils.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 1.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

extension Date {
    
    static var dateFormatter: DateFormatter {
     
        let df = DateFormatter()
        
        df.dateFormat = "dd.MM.YYYY"
        
        return df
    }
    
    static func dateFromTimestamp(_ timestamp: Double) -> Date {
    
        return Date(timeIntervalSince1970: timestamp)
    }
    
    var timestamp: Double {
        
        return self.timeIntervalSince1970
    }
    
    func withDaysOffset(_ days: Int) -> Date {
        
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    static func isEqual(firstDate: Date,
                        secondDate: Date,
                        by components: Set<Calendar.Component>) -> Bool {
        
        let firstComponents = Calendar.current.dateComponents(components, from: firstDate)
        let secondComponents = Calendar.current.dateComponents(components, from: secondDate)
        
        for component in components {
            
            switch component {
            
            case .year:
                guard let firstYear = firstComponents.year,
                      let secondYear = secondComponents.year,
                      firstYear == secondYear else {
                    
                    return false
                }
                
            case .month:
                guard let firstMonth = firstComponents.month,
                      let secondMonth = secondComponents.month,
                      firstMonth == secondMonth else {
                    
                    return false
                }
                
            case .day:
                guard let firstDay = firstComponents.day,
                      let secondDay = secondComponents.day,
                      firstDay == secondDay else {
                    
                    return false
                }
                
            default:
                break
            }
        }
        
        return true
    }
}
