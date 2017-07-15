//
//  Instruments.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct Instruments {
    
    var aud = ["AUD", "Australian Dollar"]
    var cad = ["CAD", "Canadian Dollar"]
    var chf = ["CHF", "Swiss Franc"]
    var gbp = ["GBP", "Great Britain Pound"]
    var eur = ["EUR", "Euro"]
    var nzd = ["NZD", "New Zealand Dollar"]
    var sgd = ["SGD", "Singapore Dollar"]
    var usd = ["USD", "US Dollar"]
    var jpy = ["JPY", "Japanese Yen"]
    
    var forexMajors = [
        "AUDUSD", "EURUSD", "GBPUSD",
        "USDCAD", "USDCHF", "USDJPY"
    ]
    
    var forexMinors = [
        "AUDCAD", "AUDCHF", "AUDJPY",
        "AUDNZD", "CADCHF", "CADJPY",
        "CHFJPY", "EURAUD", "EURCAD",
        "EURCHF", "EURGBP", "EURJPY",
        "EURNZD", "GBPAUD", "GBPCAD",
        "GBPCHF", "GBPJPY", "GBPNZD",
        "NZDCAD", "NZDCHF", "NZDJPY",
        "NZDUSD", "USDSGD"
    ]
    
    var forexExotics = [
        ""
    ]
    
    

}
