//
//  Localizator.swift
//  TraderCalculator
//
//  Created by Yaroslav Zhurbilo on 15.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        
        switch UserDefaultsManager().language {
            
        case Languages.System.name:
            return returnLocalizedStringForResource(Languages.System.code)
            
        case Languages.English.name:
            return returnLocalizedStringForResource(Languages.English.code)
            
        case Languages.Russian.name:
            return returnLocalizedStringForResource(Languages.Russian.code)
            
        case Languages.French.name:
            return returnLocalizedStringForResource(Languages.French.code)
            
        case Languages.Spanish.name:
            return returnLocalizedStringForResource(Languages.Spanish.code)
            
        case Languages.German.name:
            return returnLocalizedStringForResource(Languages.German.code)
            
        case Languages.Portuguese.name:
            return returnLocalizedStringForResource(Languages.Portuguese.code)
            
        case Languages.Turkish.name:
            return returnLocalizedStringForResource(Languages.Turkish.code)
            
        case Languages.Hindi.name:
            return returnLocalizedStringForResource(Languages.Hindi.code)
            
        case Languages.ChineseSimplified.name:
            return returnLocalizedStringForResource(Languages.ChineseSimplified.code)
            
        case Languages.Japanese.name:
            return returnLocalizedStringForResource(Languages.Japanese.code)
            
        case Languages.Arabic.name:
            return returnLocalizedStringForResource(Languages.Arabic.code)
            
        default:
            let bundle = Bundle.main
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
    }
    
    func returnLocalizedStringForResource(_ resource: String) -> String {
        
        let path = Bundle.main.path(forResource: resource, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        
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

//MARK: New way of localization

//private class Localizator {
//    
//    static let sharedInstance = Localizator()
//    
//    lazy var localizableDictionary: NSDictionary! = {
//        if let path = Bundle.main.path(forResource: "Localizable", ofType: "plist") {
//            return NSDictionary(contentsOfFile: path)
//        }
//        fatalError("Localizable file NOT found")
//    }()
//    
//    func localize(_ string: String) -> String {
//        guard let localizedString = (localizableDictionary.value(forKey: string) as AnyObject).value(forKey: "value") as? String else {
//            assertionFailure("Missing translation for: \(string)")
//            return ""
//        }
//        return localizedString
//    }
//}
//
//extension String {
//    func localized() -> String {
//        return Localizator.sharedInstance.localize(self)
//    }
//}
