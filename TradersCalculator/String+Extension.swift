//
//  String+Extension.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 17.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

extension String {
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.characters.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.characters.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return self[startIndex ..< endIndex]
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
}

extension String {
    var myFloatConverter: Double {
        let converter = NumberFormatter()
        
        converter.decimalSeparator = ","
        if let result = converter.number(from: self) {
            return result.doubleValue
            
        } else {
            
            converter.decimalSeparator = "."
            if let result = converter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0.00
    }
}

extension String {
    func localized() -> String {
        
        switch UserDefaultsManager().language {
        case "English":
            let path = Bundle.main.path(forResource: "Base", ofType: "lproj")
            let bundle = Bundle(path: path!)!
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        case "Русский":
            let path = Bundle.main.path(forResource: "ru", ofType: "lproj")
            let bundle = Bundle(path: path!)!
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        default:
            let bundle = Bundle.main
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
    }
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
    
    func localized(lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    //    func localized() -> String {
    //        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
    //            // we set a default, just in case
    //            UserDefaults.standard.set("fr", forKey: "i18n_language")
    //            UserDefaults.standard.synchronize()
    //        }
    //
    //        let lang = UserDefaults.standard.string(forKey: "i18n_language")
    //
    //        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    //        let bundle = Bundle(path: path!)
    //
    //        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    //    }
}
