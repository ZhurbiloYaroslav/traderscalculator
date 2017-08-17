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
    fileprivate var _value: Double!         // Value means "Лот" in Russian
    fileprivate var _openPrice: Double!
    fileprivate var _stopLoss: Double!
    fileprivate var _takeProfit: Double!
    fileprivate var _dealDirection: String!
    fileprivate var _positionID: String!
    fileprivate var _rateXX1XX2: Double!
    fileprivate var _rateXX1Cur: Double!
    fileprivate var _rateCurXX2: Double!
    fileprivate var _rateXX2Cur: Double!
    
    
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
    
    //MARK: Start Methods to calculate values
    // Returns the value of Margin
    func getMargin() -> Double {
        return 1.0
    }
    
    // Returns the value of Margin
    func getProfit() -> Double {
        return 1.0
    }
    
    // Returns the value of Margin
    func getLoss() -> Double {
        return 1.0
    }
    // End of Methods to calculate values
    
    //TODO: Make description
    func roundValue(value: Double) -> Double {
        let digitsAfterDot = instrument.digitsAfterDot
        
        return value.roundTo(places: digitsAfterDot)
    }
    
    // Designated initializer
    init(creationDate: String,       instrument: [String: Any],
         value: Double,              openPrice: Double,
         stopLoss: Double,           takeProfit: Double,
         dealDirection: String,      positionID: String) {
        
        self._creationDate = creationDate
        self._instrument = Instrument(firebaseDict: instrument)
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
        var saveInstrument = [String: Any]()
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
                saveTakeProfit = takeProfit.roundTo(places: 5)
            }
        }
        
        if let instrumentStopLoss = firebaseDict["stopLoss"] as? String {
            if let stopLoss = Double(instrumentStopLoss) {
                saveStopLoss = stopLoss.roundTo(places: 5)
            }
        }
        
        if let openPrice = firebaseDict["openPrice"] as? String {
            if let openPrice = Double(openPrice) {
                saveOpenPrice = openPrice.roundTo(places: 5)
            }
        }
        
        if let instrumentValue = firebaseDict["value"] as? String {
            if let value = Double(instrumentValue) {
                saveValue = value
            }
        }
        
        if let instrument = firebaseDict["instrument"] as? [String: Any] {
            saveInstrument = instrument
        }
        
        if let creationDate = firebaseDict["creationDate"] as? String {
            saveCreationDate = creationDate
        }
        
        self.init(creationDate: saveCreationDate, instrument: saveInstrument,
                  value: saveValue, openPrice: saveOpenPrice, stopLoss: saveStopLoss,
                  takeProfit: saveTakeProfit, dealDirection: saveDealDirection, positionID: positionID)
        
    }
    
}


// Getters and Setters
extension Position {
    
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
            return roundValue(value: _takeProfit)
        } else {
            return 0
        }
    }
    
    var stopLoss: Double {
        if _stopLoss != nil {
            return roundValue(value: _stopLoss)
        } else {
            return 0
        }
    }
    
    var openPrice: Double {
        if _openPrice != nil {
            return roundValue(value: _openPrice)
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





