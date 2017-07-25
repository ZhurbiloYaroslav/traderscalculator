//
//  Constants.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 13.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation


//TODO: Make these variables not global, but in the Instruments.swift like an instance variables

//TOOD: Make comment
typealias DownloadComplete = () -> ()

struct Constants {
    
    static let defaultCurrency = Constants.currenciesOfAccount[1]
    static let defaultLanguage = Constants.languages[0]
    static let defaultLeverage = Constants.leverage[3]
        
    // Currency constants
    // Uses in options
    static let currenciesOfAccount = [
        "EUR",
        "USD",
        "RUR"
    ]
    
    // Uses in options
    static let languages = [
        "System",
        "English",
        "Русский"
    ]
    
    // "Кредитное плечо" in Russian
    // Uses in options
    static let leverage = [
        "1:1000",
        "1:500",
        "1:200",
        "1:100",
        "1:50",
        "1:25",
        "1:10"
    ]
    
    //TOOD: Make comment
    static let yahooBaseURL = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20('AUDUSD'%2C'EURUSD'%2C'GBPUSD'%2C'USDCAD'%2C'USDCHF'%2C'USDJPY'%2C'AUDCAD'%2C'AUDCHF'%2C'AUDJPY'%2C'AUDNZD'%2C'CADCHF'%2C'CADJPY'%2C'CHFJPY'%2C'EURAUD'%2C'EURCAD'%2C'EURCHF'%2C'EURGBP'%2C'EURJPY'%2C'EURNZD'%2C'GBPAUD'%2C'GBPCAD'%2C'GBPCHF'%2C'GBPJPY'%2C'GBPNZD'%2C'NZDCAD'%2C'NZDCHF'%2C'NZDJPY'%2C'NZDUSD'%2C'USDSGD'%2C'AUDSGD'%2C'CHFSGD'%2C'EURDKK'%2C'EURHKD'%2C'EURNOK'%2C'EURPLN'%2C'EURSEK'%2C'EURSGD'%2C'EURTRY'%2C'EURZAR'%2C'GBPDKK'%2C'GBPNOK'%2C'GBPSEK'%2C'GBPSGD'%2C'NOKJPY'%2C'NOKSEK'%2C'SEKJPY'%2C'SGDJPY'%2C'USDCNH'%2C'USDCZK'%2C'USDDKK'%2C'USDHKD'%2C'USDHUF'%2C'USDMXN'%2C'USDNOK'%2C'USDPLN'%2C'USDRUB'%2C'USDSEK'%2C'USDTHB'%2C'USDTRY'%2C'USDZAR'%2C%20'BTCUSD')&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    
}
