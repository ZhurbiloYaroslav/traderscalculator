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
    
    static let defaultCurrency = Constants.currenciesOfAccount[0]
    static let defaultLanguage = Constants.languages[0]
    static let defaultLeverage = Constants.leverage[3]
    
    public struct Color {
        static let blue = UIColor(red: 81/255, green: 152/255, blue: 241/255, alpha: 1)
        static let red = UIColor(red: 210/255, green: 107/255, blue: 88/255, alpha: 1)
    }
        
    // Currency constants
    // Uses in options
    static let currenciesOfAccount = [
        Currency.USD,
        Currency.EUR,
        Currency.RUB,
        Currency.UAH,
        Currency.AUD,
        Currency.GBP,
        Currency.CAD,
        Currency.CHF,
        Currency.JPY,
        Currency.NZD,
        Currency.CNH,
        Currency.CZK,
        Currency.DKK,
        Currency.HKD,
        Currency.HUF,
        Currency.MXN,
        Currency.NOK,
        Currency.PLN,
        Currency.SEK,
        Currency.THB,
        Currency.TRY,
        Currency.ZAR
    ]
    
    // Uses in options
    static let languages = [
        Languages.System.name,
        Languages.English.name,
        Languages.Russian.name,
        Languages.French.name,
        Languages.Spanish.name,
        Languages.German.name,
        Languages.Portuguese.name,
        Languages.Turkish.name,
        Languages.Hindi.name,
        Languages.ChineseSimplified.name,
        Languages.Japanese.name,
        Languages.Arabic.name
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
