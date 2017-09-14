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
            else { return [EUR,USD] }
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
            
            [AUD,USD],
            [EUR,USD],
            [GBP,USD],
            [USD,CAD],
            [USD,CHF],
            [USD,JPY]
            
        ],

        "Forex Minors": [
            
            [AUD,CAD],
            [AUD,CHF],
            [AUD,JPY],
            [AUD,NZD],
            [CAD,CHF],
            [CAD,JPY],
            [CHF,JPY],
            [EUR,AUD],
            [EUR,CAD],
            [EUR,CHF],
            [EUR,GBP],
            [EUR,JPY],
            [EUR,NZD],
            [GBP,AUD],
            [GBP,CAD],
            [GBP,CHF],
            [GBP,JPY],
            [GBP,NZD],
            [NZD,CAD],
            [NZD,CHF],
            [NZD,JPY],
            [NZD,USD],
            [USD,SGD]
        
        ],
        
        "Forex Exotics": [
            
            [AUD,SGD],
            [CHF,SGD],
            [EUR,DKK],
            [EUR,HKD],
            [EUR,NOK],
            [EUR,PLN],
            [EUR,SEK],
            [EUR,SGD],
            [EUR,TRY],
            [EUR,ZAR],
            [GBP,DKK],
            [GBP,NOK],
            [GBP,SEK],
            [GBP,SGD],
            [NOK,JPY],
            [NOK,SEK],
            [SEK,JPY],
            [SGD,JPY],
            [USD,CNH],
            [USD,CZK],
            [USD,DKK],
            [USD,HKD],
            [USD,HUF],
            [USD,MXN],
            [USD,NOK],
            [USD,PLN],
            [USD,RUB],
            [USD,SEK],
            [USD,THB],
            [USD,TRY],
            [USD,ZAR]
            
        ],
        
        "Crypto": [
            
            [BTC,USD]
        ],
        
        "Energies": [
            
            [XBR,USD],
            [XNG,USD],
            [XTI,USD]
        ],
        
        "Indeices CFDs": [
            
            [AUS200]
        ],
        
        "Futures CFDs": [
            
            [DXY_U7],
            [VIX_M7],
            [VIX_N7]
        ],
        
        "Commodity CFDs": [
            
            [BRENT_Q7],
            [BRENT_U7],
            [Coffee_N7],
            [Coffee_U7],
            [Corn_N7],
            [Soybean_N7],
            [Sugar_N7],
            [WTI_Q7],
            [Wheat_N7]
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





