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
    
    private var _instrumentParts: [String]!
    private var _instrumentCategory: String!
    

    
    //TODO: Write a description
    var instrumentParts: [String] {
        
        if _instrumentParts != nil {
            return _instrumentParts
        } else {
            return []
        }
        
    }
    
    //TODO: Write a description
    var instrumentCategory: String {
        
        if _instrumentCategory != nil {
            return _instrumentCategory
        } else {
            return ""
        }
        
    }
    
    //TODO: Write a description
    var countOfinstrumentParts: Int {
        
        if _instrumentParts != nil {
            return self._instrumentParts.count
        } else {
            return 0
        }
    }
    
    //TODO: Write a description
    var instrumentString: String {
        
        if _instrumentParts != nil {
            
            var resultString = ""
            
            for part in _instrumentParts {
                resultString += part
            }
            
            return resultString
            
        } else {
            return ""
        }
        
    }
    
    //TODO: Write a description
    init(_ categoryName: String, _ instrumentParts: [String]) {
        
        self._instrumentParts = instrumentParts
        self._instrumentCategory = categoryName
        
    }
    
    convenience init() {
        self.init("", [])
    }
}








