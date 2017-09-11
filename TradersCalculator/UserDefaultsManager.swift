//
//  UserDefaultsManager.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 22.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import CoreData

class UserDefaultsManager {
    
    private let defaults = UserDefaults.standard
    
    private var options: [String: String] {
        
        get {
            return defaults.object(forKey: "options") as? [String: String] ?? [String: String]()
        }
        set {
            defaults.set(newValue, forKey: "options")
            defaults.synchronize()
        }
        
    }
    
    var lastUsedInstrument: LastUsedInstrument {
        
        get {
            if let data = defaults.object(forKey: "lastUsedInstrument") as? [String : Int] {
                return LastUsedInstrument(data: data)
            } else {
                return LastUsedInstrument()
            }
            
        }
        
        set {
            defaults.set(newValue.getDictForSave(), forKey: "lastUsedInstrument")
            defaults.synchronize()
        }
        
    }
    
    var cachedInstrumentsRates: InstrumentsRates {
        
        get {
            if let data = defaults.object(forKey: "instrumentsRates") as? [String : Any] {
                return InstrumentsRates(data: data)
            } else {
                return InstrumentsRates()
            }
        }
        
        set {
            defaults.set(newValue.getDictForSave(), forKey: "instrumentsRates")
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
    var accountCurrency: String? {
        get {
            return self.options["accountCurrency"] ?? nil
        }
        set {
            self.options["accountCurrency"] = newValue
        }
    }
    
    //TODO: Make comment
    var leverage: String? {
        get {
            return self.options["leverage"] ?? nil
        }
        set {
            self.options["leverage"] = newValue
        }
    }
    
    //TODO: Make comment
    var isProVersion: Bool {
        get {
            return (self.options["isProVersion"] == "true") ? true : false
        }
        set {
            self.options["isProVersion"] = String(newValue)
        }
    }
    //TODO: Make comment
    var numberForNextListOfPositionsName: String {
        get {
            
            guard let stringValue = self.options["numberForNextListOfPositionsName"] else {
                self.options["numberForNextListOfPositionsName"] = "1"
                return "1"
            }
            guard var number = Int(stringValue) else {
                self.options["numberForNextListOfPositionsName"] = "1"
                return "1"
            }
            
            number += 1
            
            let stringWithNewNumber = "\(number)"
            self.options["numberForNextListOfPositionsName"] = stringWithNewNumber
            return stringWithNewNumber
            
        }
    }
    
    var currentListOfPositionsID: URL? {
        
        get {
            return defaults.url(forKey: "currentListOfPositionsID") ?? nil
        }
        
        set {
            defaults.set(newValue, forKey: "currentListOfPositionsID")
            defaults.synchronize()
        }
        
    }
    
    var amountOfExports: Int {
        
        get {
            return defaults.object(forKey: "amountOfExports") as? Int ?? 0
        }
        set {
            defaults.set(newValue, forKey: "amountOfExports")
            defaults.synchronize()
        }
        
    }
    
}
