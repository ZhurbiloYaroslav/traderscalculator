//
//  Position.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 16.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

//TODO: Write a description
class Position {
    
    fileprivate var _creationDate: String!
    fileprivate var _instrument: Instrument!
    fileprivate var _instrumentCategory: String
    fileprivate var _value: Double!         // Value means "Лот" in Russian
    fileprivate var _openPrice: Double!
    fileprivate var _stopLoss: Double!
    fileprivate var _takeProfit: Double!
    fileprivate var _dealDirection: DealDirection!
    
    var marga: Double {
        return _value / _openPrice
    }
    
    //TODO: Write a description
    enum DealDirection: String {
        case Sell
        case Buy
        case NoDirection
    }
    
    // Designated initializer
    init(creationDate: String,       instrument: Instrument,
         instrumentCategory: String, value: Double,
         openPrice: Double,          stopLoss: Double,
         takeProfit: Double,         dealDirection: DealDirection) {
        
        self._creationDate = creationDate
        self._instrument = instrument
        self._instrumentCategory = instrumentCategory
        self._value = value
        self._openPrice = openPrice
        self._stopLoss = stopLoss
        self._takeProfit = takeProfit
        self._dealDirection = dealDirection
        
    }
    
//    //TODO: Write a description
//    convenience init(instrumentID: String, firebaseDict: [String:Any]) {
//        
//        // Check Data before initialize
//        var saveCreationDate = ""
//        var saveInstrument = ""
//        var saveValue = 0
//        var saveOpenPrice = 0
//        var saveStopLoss = 0
//        var saveTakeProfit = 0
//        var saveDealDirection = DealDirection.NoDirection
//        
//        
//        // Assign previous variables with values
//        
//        if let instrument = firebaseDict["instrument"] as? String {
//            saveInstrument = instrument
//        }
//        
//        if let creationDate = firebaseDict["creationDate"] as? String {
//            saveCreationDate = creationDate
//        }
//        
//        //..........Do the same for all variables.........
//        
//    }
    
}


// Getters and Setters
extension Position {
    
    
    var dealDirection: DealDirection {
        if _dealDirection != nil {
            return _dealDirection
        } else {
            return .NoDirection
        }
    }
    
    var takeProfit: Double {
        if _takeProfit != nil {
            return _takeProfit
        } else {
            return 0
        }
    }
    
    var stopLoss: Double {
        if _stopLoss != nil {
            return _stopLoss
        } else {
            return 0
        }
    }
    
    var openPrice: Double {
        if _openPrice != nil {
            return _openPrice
        } else {
            return 0
        }
    }
    
    var value: Double {
        if _value != nil {
            return _value
        } else {
            return 0
        }
    }
    
    var instrument: Instrument {
        if _instrument != nil {
            return _instrument
        } else {
            return Instrument()
        }
    }
    
    var creationDate: String {
        if _creationDate != nil {
            return _creationDate
        } else {
            return ""
        }
    }
    
}





