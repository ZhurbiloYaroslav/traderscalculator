//
//  CurrentUser.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 22.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class CurrentUser {
    
    private let defaults = UserDefaults.standard
    
    var options: [String: String] {
        
        get {
            return defaults.object(forKey: "options") as? [String: String] ?? [String: String]()
        }
        set {
            defaults.set(newValue, forKey: "options")
            defaults.synchronize()
        }
        
    }
    
    var language: String {
        get {
            return self.options["language"] ?? ""
        }
        set {
            self.options["language"] = newValue
        }
    }
    
    var accountCurrency: String {
        get {
            return self.options["accountCurrency"] ?? ""
        }
        set {
            self.options["accountCurrency"] = newValue
        }
    }
    
    var leverage: String {
        get {
            return self.options["leverage"] ?? ""
        }
        set {
            self.options["leverage"] = newValue
        }
    }
    
}
