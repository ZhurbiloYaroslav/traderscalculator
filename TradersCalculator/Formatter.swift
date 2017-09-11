//
//  Formatter.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class Formatter {
    
    static func getFormatted(date: NSDate) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
        
    }
    
}
