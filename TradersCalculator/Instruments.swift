//
//  Instruments.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct Instruments {
    // This should be named as Symbol(s)
    //TODO: Make comment
    
    //TODO: Make comment
    var defaultCategory: String {
        return categories[0]
    }
    
    //TODO: Make comment
    var defaultInstrumentPair: [String] {
        guard let defInstrPair = categoriesAndInstruments["Forex Majors"]?[0]
            else { return [Currency.EUR,Currency.USD] }
        return defInstrPair
    }
    
    //TODO: Make comment
    var categories = [
        "Forex Majors",
        "Forex Minors",
        "Forex Exotics",
        //"Crypto",
        //"Energies",
        //"Indeices CFDs",
        //"Futures CFDs",
        //"Commodity CFDs"
    ]
    
    //TODO: Make comment
    var categoriesAndInstruments = [
        
        "Forex Majors": [
            
            [Currency.AUD, Currency.USD],
            [Currency.EUR, Currency.USD],
            [Currency.GBP, Currency.USD],
            [Currency.USD, Currency.CAD],
            [Currency.USD, Currency.CHF],
            [Currency.USD, Currency.JPY]
            
        ],

        "Forex Minors": [
            
            [Currency.AUD, Currency.CAD],
            [Currency.AUD, Currency.CHF],
            [Currency.AUD, Currency.JPY],
            [Currency.AUD, Currency.NZD],
            [Currency.CAD, Currency.CHF],
            [Currency.CAD, Currency.JPY],
            [Currency.CHF, Currency.JPY],
            [Currency.EUR, Currency.AUD],
            [Currency.EUR, Currency.CAD],
            [Currency.EUR, Currency.CHF],
            [Currency.EUR, Currency.GBP],
            [Currency.EUR, Currency.JPY],
            [Currency.EUR, Currency.NZD],
            [Currency.GBP, Currency.AUD],
            [Currency.GBP, Currency.CAD],
            [Currency.GBP, Currency.CHF],
            [Currency.GBP, Currency.JPY],
            [Currency.GBP, Currency.NZD],
            [Currency.NZD, Currency.CAD],
            [Currency.NZD, Currency.CHF],
            [Currency.NZD, Currency.JPY],
            [Currency.NZD, Currency.USD],
            [Currency.USD, Currency.SGD]
        
        ],
        
        "Forex Exotics": [
            
            [Currency.AUD, Currency.SGD],
            [Currency.CHF, Currency.SGD],
            [Currency.EUR, Currency.DKK],
            [Currency.EUR, Currency.HKD],
            [Currency.EUR, Currency.NOK],
            [Currency.EUR, Currency.PLN],
            [Currency.EUR, Currency.SEK],
            [Currency.EUR, Currency.SGD],
            [Currency.EUR, Currency.TRY],
            [Currency.EUR, Currency.ZAR],
            [Currency.GBP, Currency.DKK],
            [Currency.GBP, Currency.NOK],
            [Currency.GBP, Currency.SEK],
            [Currency.GBP, Currency.SGD],
            [Currency.NOK, Currency.JPY],
            [Currency.NOK, Currency.SEK],
            [Currency.SEK, Currency.JPY],
            [Currency.SGD, Currency.JPY],
            [Currency.USD, Currency.CNH],
            [Currency.USD, Currency.CZK],
            [Currency.USD, Currency.DKK],
            [Currency.USD, Currency.HKD],
            [Currency.USD, Currency.HUF],
            [Currency.USD, Currency.MXN],
            [Currency.USD, Currency.NOK],
            [Currency.USD, Currency.PLN],
            [Currency.USD, Currency.RUB],
            [Currency.USD, Currency.SEK],
            [Currency.USD, Currency.THB],
            [Currency.USD, Currency.TRY],
            [Currency.USD, Currency.ZAR]
            
        ],
        
        "Crypto": [
            
            [Currency.BTC, Currency.USD]
        ],
        
        "Energies": [
            
            [Currency.XBR, Currency.USD],
            [Currency.XNG, Currency.USD],
            [Currency.XTI, Currency.USD]
        ],
        
        "Indeices CFDs": [
            
            [Index.AUS200]
        ],
        
        "Futures CFDs": [
            
            [Index.DXY_U7],
            [Index.VIX_M7],
            [Index.VIX_N7]
        ],
        
        "Commodity CFDs": [
            
            [Index.BRENT_Q7],
            [Index.BRENT_U7],
            [Index.Coffee_N7],
            [Index.Coffee_U7],
            [Index.Corn_N7],
            [Index.Soybean_N7],
            [Index.Sugar_N7],
            [Index.WTI_Q7],
            [Index.Wheat_N7]
        ]

    ]

}

// Methods that helps retrieve the data for Picker View during Adding a Position
extension Instruments {
    
    
    //TODO: Write a description
    func getCategoryNameBy(categoryID: Int) -> String {
        
        return categories[categoryID]
        
    }
    
    //TODO: Write a description
    func getRightCurrencyPairsArrayFor(instrumentID: Int, inCategoryID: Int) -> [String] {
        
        var resultArray = [String]()
        
        let categoryName = categories[inCategoryID]
        
        let arrayWithInstrumentsParts = categoriesAndInstruments[categoryName]
        
        guard let instrumentParts = arrayWithInstrumentsParts else {
            return [String]()
        }
        
        //TODO: Write a description
        let currentInstrumentName = self.getArrayWithInstrumentsBy(categoryID: inCategoryID)[instrumentID]
        
        //TODO: Write a description
        for instrumentPart in instrumentParts {
            
            //TODO: Write a description
            if instrumentPart.indices.contains(1) {
                
                //TODO: Write a description
                if instrumentPart[0] == currentInstrumentName {
                    resultArray.append(instrumentPart[1])
                }
                
            }
            
        }
        
        return resultArray
    }
    
    //TODO: Write a description
    func getArrayWithInstrumentsBy(categoryID: Int) -> [String] {
        
        var arrayWithInstruments = [String]()
        
        let categoryName = categories[categoryID]
        
        let arrayWithInstrumentsParts = categoriesAndInstruments[categoryName]
        
        guard let unwrappedArrayWithInstrumentsParts = arrayWithInstrumentsParts else {
            return [String]()
        }
        
        //TODO: Write a description
        for instrumentParts in unwrappedArrayWithInstrumentsParts {
            
            if arrayWithInstruments.contains(instrumentParts[0]) == false {
                arrayWithInstruments.append(instrumentParts[0])
            }
            
        }
        
        return arrayWithInstruments
    }
    
    //TODO: Write a description
    func getInstrumentNameBy(categoryID: Int, leftPart: Int, rightPart: Int) -> String {
        
        var result = ""
        
        let leftPartName = self.getArrayWithInstrumentsBy(categoryID: categoryID)[leftPart]
        result = leftPartName
        
        let rightPartName = self.getRightCurrencyPairsArrayFor(instrumentID: leftPart, inCategoryID: categoryID)
        
        if rightPartName.isEmpty == false {
            result += rightPartName[rightPart]
        }
        
        return result
    }
    
    //TODO: Get object of the instrument to retrieve a description fo Symbol
    func getInstrumentParts(categoryID: Int, leftPart: Int, rightPart: Int) -> [String] {
        
        var instrumentParts = [String]()
        let instrumentsLeftPartArray = getArrayWithInstrumentsBy(categoryID: categoryID)
        let instrumentsRightPartArray = getRightCurrencyPairsArrayFor(instrumentID: leftPart, inCategoryID: categoryID)
        
        for instrumentIndex in 0 ..< instrumentsLeftPartArray.count {
            
            if instrumentIndex == leftPart {
                instrumentParts.append(instrumentsLeftPartArray[instrumentIndex])
            }
            
        }
        
        for instrumentIndex in 0 ..< instrumentsRightPartArray.count {
            
            if instrumentIndex == rightPart {
                instrumentParts.append(instrumentsRightPartArray[instrumentIndex])
            }
            
        }

        return instrumentParts
        
    }
}





