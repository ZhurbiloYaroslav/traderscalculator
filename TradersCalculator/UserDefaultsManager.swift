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
    //TODO: Make comment
    
    private let defaults = UserDefaults.standard
    
    //TODO: Make comment
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
    var isProVersion: String {
        get {
            return self.options["isProVersion"] ?? "false"
        }
        set {
            self.options["isProVersion"] = newValue
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
    
    //TODO: Make comment
    var currentListOfPositionsID: URL? {
        
        get {
            return defaults.url(forKey: "currentListOfPositionsID") ?? nil
        }
        
        set {
            defaults.set(newValue, forKey: "currentListOfPositionsID")
            defaults.synchronize()
        }
        
    }
    
}
