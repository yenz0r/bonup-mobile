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
}
