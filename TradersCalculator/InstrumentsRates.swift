//
//  InstrumentsRates.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 28.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct InstrumentsRates {
    
    var rates: [String: String]!
    var date: String!
    
    //MARK: Initializer Designated
    init(rates: [String: String], date: String) {
        self.rates = rates
        self.date = date
    }
    
    //MARK: Initializer Convenience
    init() {
        self.init(rates: [String: String](), date: "")
    }
    
    //MARK: Initializer Convenience for retrieve info from DB
    init(data: [String: Any]) {
        
        var rates = [String: String]()
        var date = ""
        
        if let _rates = data["rates"] as? [String: String] {
            rates = _rates
        }
        
        if let _date = data["date"] as? String {
            date = _date
        }
        
        self.init(rates: rates, date: date)
    }
    
    func getDictForSave() -> Dictionary<String, Any> {
        return [
            "rates" : rates,
            "date" : date
        ]
    }
    
}
