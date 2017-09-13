//
//  Constants.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 13.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation

//TODO: Make these variables not global, but in the Instruments.swift like an instance variables

//TOOD: Make comment
typealias DownloadComplete = () -> ()

struct Constants {
    
    struct Color {
        static let blue = UIColor(red: 81/255, green: 152/255, blue: 241/255, alpha: 1)
        static let red = UIColor(red: 210/255, green: 107/255, blue: 88/255, alpha: 1)
    }
    
    static let bundleID = "com.soft4status.TradersCalculator"
    //    static let bundleID = "com.diglabstudio.TraderCalculator"
    
    static let defaultCurrency = Constants.currenciesOfAccount[0]
    static let defaultLanguage = Constants.languages[0]
    static let defaultLeverage = Constants.leverage[3]
    
    // Currency constants
    // Uses in options
    static let currenciesOfAccount = [
        "USD",
        "EUR",
        "RUB",
        "AUD",
        "GBP",
        "CAD",
        "CHF",
        "JPY",
        "NZD",
        "CNH",
        "CZK",
        "DKK",
        "HKD",
        "HUF",
        "MXN",
        "NOK",
        "PLN",
        "SEK",
        "THB",
        "TRY",
        "ZAR"
    ]
    
    // Uses in options
    static let languages = [
        "System",
        "English",
        "Русский",
        "Français",
        "Español",
        "Deutsch",
        "Português",
        "Türkçe",
        "हिन्दी",
        "中国",
        "日本語",
               "العربية"
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
}
