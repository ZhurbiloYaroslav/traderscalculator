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
    fileprivate var _instrument: String!
    fileprivate var _instrumentParts: [String]!
    fileprivate var _instrumentCategory: String!
    fileprivate var _value: Double!         // Value means "Лот" in Russian
    fileprivate var _openPrice: Double!
    fileprivate var _stopLoss: Double!
    fileprivate var _takeProfit: Double!
    fileprivate var _dealDirection: String!
    fileprivate var _positionID: String!
    
    
    /*
     private static let formatter: NSDateFormatter = {
     let formatter = NSDateFormatter()
     formatter.dateFormat = "MM/dd/yyyy HH:mma"
     return formatter
     
     }
     
     static func dateFromString(string : String) -> NSDate? {
     return formatter.dateFromString(string)
     }
     */
    
    //TODO: Write a description
    enum DealDirection: String {
        case Sell
        case Buy
        case NoDirection
    }
    
    // Designated initializer
    init(creationDate: String,       instrument: String,
         instrumentParts: [String],  instrumentCategory: String,
         value: Double,              openPrice: Double,
         stopLoss: Double,           takeProfit: Double,
         dealDirection: String,      positionID: String) {
        
        self._creationDate = creationDate
        self._instrument = instrument
        self._instrumentParts = instrumentParts
        self._instrumentCategory = instrumentCategory
        self._value = value
        self._openPrice = openPrice
        self._stopLoss = stopLoss
        self._takeProfit = takeProfit
        self._dealDirection = dealDirection
        self._positionID = positionID
        
    }
    
    //TODO: Write a description
    convenience init(_ positionID: String, _ firebaseDict: [String:Any]) {
        
        // Check Data before initialize
        
        // Set default values
        var saveCreationDate = ""
        var saveInstrument = ""
        var saveInstrumentParts = [String]()
        var saveInstrumentCategory = ""
        var saveValue: Double = 0
        var saveOpenPrice: Double = 0
        var saveStopLoss: Double = 0
        var saveTakeProfit: Double = 0
        var saveDealDirection = ""
        
        
        // Assign previous variables with values
        
        if let instrumentDealDirection = firebaseDict["dealDirection"] as? String {
            saveDealDirection = instrumentDealDirection
        }
        
        if let instrumentTakeProfit = firebaseDict["takeProfit"] as? String {
            if let takeProfit = Double(instrumentTakeProfit) {
                saveTakeProfit = takeProfit
            }
        }
        
        if let instrumentStopLoss = firebaseDict["stopLoss"] as? String {
            if let stopLoss = Double(instrumentStopLoss) {
                saveStopLoss = stopLoss
            }
        }
        
        if let openPrice = firebaseDict["openPrice"] as? String {
            if let openPrice = Double(openPrice) {
                saveOpenPrice = openPrice
            }
        }
        
        if let instrumentValue = firebaseDict["value"] as? String {
            if let value = Double(instrumentValue) {
                saveValue = value
            }
        }
        
        if let instrumentCategory = firebaseDict["category"] as? String {
            saveInstrumentCategory = instrumentCategory
        }
        
        if let instrumentParts = firebaseDict["instrumentParts"] as? [String] {
            saveInstrumentParts = instrumentParts
        }
        
        if let instrument = firebaseDict["instrument"] as? String {
            saveInstrument = instrument
        }
        
        if let creationDate = firebaseDict["creationDate"] as? String {
            saveCreationDate = creationDate
        }
        
        self.init(creationDate: saveCreationDate, instrument: saveInstrument,
                  instrumentParts: saveInstrumentParts, instrumentCategory: saveInstrumentCategory,
                  value: saveValue, openPrice: saveOpenPrice, stopLoss: saveStopLoss,
                  takeProfit: saveTakeProfit, dealDirection: saveDealDirection, positionID: positionID)
        
    }
    
}


// Getters and Setters
extension Position {
    
    var instrumentParts: [String] {
        if _instrumentParts != nil {
            return _instrumentParts
        } else {
            return [String]()
        }
    }
    
    var instrumentCategory: String {
        if _instrumentCategory != nil {
            return _instrumentCategory
        } else {
            return ""
        }
    }
    
    var positionID: String {
        if _positionID != nil {
            return _positionID
        } else {
            return ""
        }
    }
    
    var dealDirection: String {
        if _dealDirection != nil {
            return _dealDirection
        } else {
            return ""
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
    
    var instrument: String {
        if _instrument != nil {
            return _instrument
        } else {
            return ""
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





