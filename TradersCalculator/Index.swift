//
//  Index.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 17.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation


struct Index {
    
    // Indeices CFDs
    static let AUS200 = "^AXJO"        // finance.yahoo.com/quote/%5EAXJO/history?p=^AXJO
    static let CHINA50 = "HD8.SI"      // finance.yahoo.com/quote/HD8.SI/history?p=HD8.SI
    static let DE30 = "DE30"           // finance.yahoo.com/quote/DE30/history?p=DE30
    static let ES35 = ""               // ?
    static let F40 = "^FCHI"           // finance.yahoo.com/quote/%5EFCHI/history?p=^FCHI
    static let HK50 = "^HSI"           // finance.yahoo.com/quote/%5EHSI/history?p=^HSI
    static let IT40 = ""               // ?
    static let JP225 = "^N225"         // finance.yahoo.com/quote/%5EN225/history?p=^N225
    static let STOXX50 = "^STOXX50E"   // finance.yahoo.com/quote/%5ESTOXX50E?p=^STOXX50E
    static let UK100 = "^FTSE"         // finance.yahoo.com/quote/%5EFTSE?p=^FTSE
    static let US2000 = ""             // ?        // ru.investing.com/indices/smallcap-2000-futures
    static let US30 = ""               // ?        // ru.investing.com/indices/us-30-futures
    static let US500 = "^GSPC"         // finance.yahoo.com/quote/%5EGSPC?p=^GSPC
    static let USTEC = ""              // ?        // finance.rambler.ru/mirovye-indeksy/quote/usa-tech-100-NQ/
    
    // Futures CFDs
    static let DXY_U7 = "DXY_U7"
    static let VIX_M7 = "VIX_M7"
    static let VIX_N7 = "VIX_N7"
    
    // Commodity CFDs
    static let BRENT_Q7 = "BZU17.NYM"      // finance.yahoo.com/quote/BZU17.NYM?p=BZU17.NYM
    static let BRENT_U7 = "BRENT_U7"       //
    static let Coffee_N7 = "Coffee_N7"
    static let Coffee_U7 = "Coffee_U7"
    static let Corn_N7 = "Corn_N7"
    static let Soybean_N7 = "Soybean_N7"
    static let Sugar_N7 = "Sugar_N7"
    static let WTI_Q7 = "WTI_Q7"
    static let Wheat_N7 = "Wheat_N7"

    
}

