//
//  Index.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 17.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation


//TODO: Make these variables not global, but in the Instruments.swift like an instance variables

// Indeices CFDs
let AUS200 = "^AXJO"        // finance.yahoo.com/quote/%5EAXJO/history?p=^AXJO
let CHINA50 = "HD8.SI"      // finance.yahoo.com/quote/HD8.SI/history?p=HD8.SI
let DE30 = "DE30"           // finance.yahoo.com/quote/DE30/history?p=DE30
let ES35 = ""               // ?
let F40 = "^FCHI"           // finance.yahoo.com/quote/%5EFCHI/history?p=^FCHI
let HK50 = "^HSI"           // finance.yahoo.com/quote/%5EHSI/history?p=^HSI
let IT40 = ""               // ?
let JP225 = "^N225"         // finance.yahoo.com/quote/%5EN225/history?p=^N225
let STOXX50 = "^STOXX50E"   // finance.yahoo.com/quote/%5ESTOXX50E?p=^STOXX50E
let UK100 = "^FTSE"         // finance.yahoo.com/quote/%5EFTSE?p=^FTSE
let US2000 = ""             // ?        // ru.investing.com/indices/smallcap-2000-futures
let US30 = ""               // ?        // ru.investing.com/indices/us-30-futures
let US500 = "^GSPC"         // finance.yahoo.com/quote/%5EGSPC?p=^GSPC
let USTEC = ""              // ?        // finance.rambler.ru/mirovye-indeksy/quote/usa-tech-100-NQ/

// Futures CFDs
let DXY_U7 = "DXY_U7"
let VIX_M7 = "VIX_M7"
let VIX_N7 = "VIX_N7"

// Commodity CFDs
let BRENT_Q7 = "BZU17.NYM"      // finance.yahoo.com/quote/BZU17.NYM?p=BZU17.NYM
let BRENT_U7 = "BRENT_U7"       //
let Coffee_N7 = "Coffee_N7"
let Coffee_U7 = "Coffee_U7"
let Corn_N7 = "Corn_N7"
let Soybean_N7 = "Soybean_N7"
let Sugar_N7 = "Sugar_N7"
let WTI_Q7 = "WTI_Q7"
let Wheat_N7 = "Wheat_N7"
