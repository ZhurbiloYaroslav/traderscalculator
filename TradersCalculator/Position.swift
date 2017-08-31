//
//  Position.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 30.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

public class Position {
    
    fileprivate var _creationDate: String!
    fileprivate var _instrument: Instrument!
    fileprivate var _value: Double!         // Value means "Лот" in Russian
    fileprivate var _openPrice: Double!
    fileprivate var _stopLoss: Double!
    fileprivate var _takeProfit: Double!
    fileprivate var _dealDirection: String!
    fileprivate var _positionID: String!
    
    private let digitsAfterDotForResultValues = 2
    
    
    //TODO: Write a description
    enum DealDirection: String {
        case Sell
        case Buy
        case NoDirection
    }
    
    //MARK: Start Methods to calculate values
    // Returns the value of Margin
    func getMargin() -> String {
        
        let formatString = "%.\(digitsAfterDotForResultValues)f"
        let margin = Double(Calculator(position: self).getMargin())
        let formattedMargin = String(format: formatString, margin)
        return formattedMargin
        
    }
    
    // Returns the value of Margin
    func getProfit() -> String {
        
        let formatString = "%.\(digitsAfterDotForResultValues)f"
        let profit = Calculator(position: self).getProfit()
        let formattedProfit = String(format: formatString, profit)
        return formattedProfit
    }
    
    // Returns the value of Margin
    func getLoss() -> String {
        
        let formatString = "%.\(digitsAfterDotForResultValues)f"
        let loss = Calculator(position: self).getLoss()
        let formattedLoss = String(format: formatString, loss)
        return formattedLoss
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

// Get Current Rates For Calculation
extension Position {
    
    public var currentRateXX1XX2: Double {
        return getRateValueFor(_currencyPairXX1XX2Name)
    }
    
    public var currentRateXX1USD: Double {
        return getRateValueFor(_currencyPairXX1USDName)
    }
    
    public var currentRateXX2USD: Double {
        return getRateValueFor(_currencyPairXX2USDName)
    }
    
    public var currentRateUSDXX1: Double {
        return getRateValueFor(_currencyPairUSDXX1Name)
    }
    
    public var currentRateUSDXX2: Double {
        return getRateValueFor(_currencyPairUSDXX2Name)
    }
    
    fileprivate var _currencyPairXX1XX2Name: String {
        return instrument.concatenateParts()
    }
    
    fileprivate var _currencyPairXX1USDName: String {
        return "\(_instrument.parts[0])USD"
    }
    
    fileprivate var _currencyPairXX2USDName: String? {
        if instrument.parts.indices.contains(1) {
            return "\(instrument.parts[1])USD"
        } else {
            return nil
        }
    }
    
    fileprivate var _currencyPairUSDXX1Name: String? {
        return "USD\(instrument.parts[0])"
    }
    
    fileprivate var _currencyPairUSDXX2Name: String? {
        if instrument.parts.indices.contains(1) {
            return "USD\(instrument.parts[1])"
        } else {
            return nil
        }
    }
    
    fileprivate func getRateValueFor(_ rateName: String?) -> Double {
        
        guard let rateName = rateName else {
            return 0
        }
        
        guard let rateString = ForexAPI().ratesByInstrumentName[rateName] else {
            return 0
        }
        
        guard let rateValue = Double(rateString) else {
            return 0
        }
        
        return rateValue
        
    }
    
    
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





