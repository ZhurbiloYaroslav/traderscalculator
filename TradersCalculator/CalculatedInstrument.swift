//
//  CalculatedInstrument.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 16.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class CalculatedInstrument {
    
    private var creationDate: String!
    private var instrument: String!
    private var value: String!         // Value means "Лот" in Russian
    private var openPrice: Double!
    private var stopLoss: Double!
    private var takeProfit: Double!
    private var dealDirection: DealDirection!
 
    enum DealDirection: String {
        case Sell
        case Buy
    }
}

// Initializers
extension CalculatedInstrument {
    
    // Designated initializer
    
    
}

// Getters and Setters
extension CalculatedInstrument {
    
    
    
}
