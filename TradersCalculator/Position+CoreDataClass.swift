//
//  Position+CoreDataClass.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 31.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import CoreData

public class Position: NSManagedObject {
    
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
    convenience init(creationDate: NSDate, instrument: Instrument,
                     value: Double, openPrice: Double,
                     stopLoss: Double, takeProfit: Double,
                     dealDirection: String) {
        
        let coreDataManager = CoreDataManager()
        let position = NSEntityDescription.entity(forEntityName: "Position", in: coreDataManager.context)!
        self.init(entity: position, insertInto: coreDataManager.context)
        
        self.creationDate = creationDate
        self.value = value
        self.openPrice = openPrice
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
        self.dealDirection = dealDirection
        self.instrument = instrument
        self.listOfPositions = coreDataManager.getAllListsOfPositions()[0]
        
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
        return "\(instrument.parts[0])USD"
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
    
}





