//
//  Constants.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 13.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

//TOOD: Make comment
typealias DownloadComplete = () -> ()

struct Constants {
    
    //TOOD: Make comment
    static let yahooBaseURL = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22AUDUSD%22%2C%20%22EURUSD%22%2C%20%22GBPUSD%22%2C%20%22USDCAD%22%2C%20%22USDCHF%22%2C%20%22USDJPY%22%2C%20%22AUDCAD%22%2C%20%22AUDCHF%22%2C%20%22AUDJPY%22%2C%20%22AUDNZD%22%2C%20%22CADCHF%22%2C%20%22CADJPY%22%2C%20%22CHFJPY%22%2C%20%22EURAUD%22%2C%20%22EURCAD%22%2C%20%22EURCHF%22%2C%20%22EURGBP%22%2C%20%22EURJPY%22%2C%20%22EURNZD%22%2C%20%22GBPAUD%22%2C%20%22GBPCAD%22%2C%20%22GBPCHF%22%2C%20%22GBPJPY%22%2C%20%22GBPNZD%22%2C%20%22NZDCAD%22%2C%20%22NZDCHF%22%2C%20%22NZDJPY%22%2C%20%22NZDUSD%22%2C%20%22USDSGD%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    
}
