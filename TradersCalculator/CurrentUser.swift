//
//  CurrentUser.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 22.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class CurrentUser {
    //TODO: Make comment
    
    private let defaults = UserDefaults.standard
    
    //TODO: Make comment
    var options: [String: String] {
        
        get {
            return defaults.object(forKey: "options") as? [String: String] ?? [String: String]()
        }
        set {
            defaults.set(newValue, forKey: "options")
            defaults.synchronize()
        }
        
    }
    
    //TODO: Make comment
    var language: String {
        get {
            return self.options["language"] ?? Constants.defaultLanguage
        }
        set {
            self.options["language"] = newValue
        }
    }
    
    //TODO: Make comment
    var accountCurrency: String {
        get {
            return self.options["accountCurrency"] ?? Constants.defaultCurrency
        }
        set {
            self.options["accountCurrency"] = newValue
        }
    }
    
    //TODO: Make comment
    var leverage: String {
        get {
            return self.options["leverage"] ?? Constants.defaultLeverage
        }
        set {
            self.options["leverage"] = newValue
        }
    }
    
    //TODO: Make comment
//    var lastUsedInstrument: Instrument {
//        get {
//            return self.options["lastUsedInstrument"] ?? Instrument()
//        }
//        set {
//            self.options["lastUsedInstrument"] = newValue
//        }
//    }
    
}
