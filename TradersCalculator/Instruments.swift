//
//  Instruments.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

struct Instruments {
    
    var categories = [
        "Forex Majors",
        "Forex Minors",
        "Forex Exotics",
        "Energies",
        "Crypto",
        "Indeices CFDs",
        "Futures CFDs",
        "Commodity CFDs"
    ]
    
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
        
        "Energies": [
            
            [XBR,USD],
            [XNG,USD],
            [XTI,USD]
        ],
        
        "Crypto": [
            
            [BTC,USD]
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
    
    // As a parameter, we should use variables of forexMajors and/or forexMinors
    // -> Dictionary<String, [String: String]>
    func getDictionaryWithInstruments()  {
        
        var dictionaryCategoryInstruments = [String : Set<String>]()
        
        for (categoryName, instrumentsArray) in categoriesAndInstruments {
            
            dictionaryCategoryInstruments.updateValue(Set<String>(), forKey: categoryName)
            
            for instrument in instrumentsArray {
                
                dictionaryCategoryInstruments[categoryName]?.update(with: instrument[0])
                
            }
            
            print(dictionaryCategoryInstruments[categoryName]!)
            
        }
        
    }
    
    
    

}






