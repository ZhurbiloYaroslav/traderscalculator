//
//  Instrument.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 19.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

//TODO: Write a description
class Instrument {
    
    private var _parts: [String]!
    private var _category: String!
    
    // This is a name of The instrument
    var name: String {
        
        var name = ""
        for instrumentPart in _parts {
            name += instrumentPart
        }
        
        return name
    }
    
    //TODO: Write a description
    var digitsBeforeAndAfterDot: [Int] {
        
        if _parts != nil {
            
            for instrumentPart in _parts {
                
                switch instrumentPart {
                case "JPY":
                    return [3,3]
                default:
                    return [1,5]
                }
            }
            
        }
        
        return [1,5]
        
    }
    
    //TODO: Write a description
    var instrumentParts: [String] {
        
        if _parts != nil {
            return _parts
        } else {
            return []
        }
        
    }
    
    //TODO: Write a description
    var instrumentCategory: String {
        
        if _category != nil {
            return _category
        } else {
            return ""
        }
        
    }
    
    //TODO: Write a description
    var countOfinstrumentParts: Int {
        
        if _parts != nil {
            return self._parts.count
        } else {
            return 0
        }
    }
    
    //TODO: Write a description
    var instrumentString: String {
        
        if _parts != nil {
            
            var resultString = ""
            
            for part in _parts {
                resultString += part
            }
            
            return resultString
            
        } else {
            return ""
        }
        
    }
    
    //TODO: Write a description
    init(_ categoryName: String, _ instrumentParts: [String]) {
        
        self._parts = instrumentParts
        self._category = categoryName
        
    }
    
    convenience init() {
        self.init(Instruments().defaultCategory, Instruments().defaultInstrumentPair)
    }
}








