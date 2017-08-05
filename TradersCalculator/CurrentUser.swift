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
    
}
