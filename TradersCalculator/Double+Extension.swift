//
//  Double+Extension.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 05.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

extension Double {
    
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
