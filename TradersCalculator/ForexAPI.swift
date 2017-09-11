//
//  ForexAPI.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import Alamofire

class ForexAPI {
    
    var ratesByInstrumentName: Dictionary<String, String>!
    
    func downloadInstrumentsRates(completed: @escaping DownloadComplete) {
        
        guard let url = URL(string: Constants.instaForexBaseURL) else { return }
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let resourcesArray = response.result.value as? [Dictionary<String, Any>] else {
                return
            }
            
            for resource in resourcesArray {
                
                guard let instrumentName = resource["symbol"] as? String else {
                    return
                }
                
                guard let instrumentRate = resource["bid"] as? Double else {
                    return
                }
                
                let correctInstrumentName = self.replaceInstrumentNameWithCorrect(instrumentName)
                
                let digitsAfterDotInInstrument = correctInstrumentName.contains("JPY") ? 3 : 5
                let formatString = "%.\(digitsAfterDotInInstrument)f"
                
                self.ratesByInstrumentName.updateValue(String(format: formatString, instrumentRate), forKey: correctInstrumentName)
                
            }
            
            self.saveLastRatesToUserDefaults()
            
            completed()
        }
        
    }
    
    func replaceInstrumentNameWithCorrect(_ instrumentName: String) -> String {
        switch instrumentName {
        case let x where x.contains("RUR"):
            return instrumentName.replacingOccurrences(of: "RUR", with: "RUB")
        case "#Bitcoin":
            return instrumentName.replacingOccurrences(of: "#Bitcoin", with: "BTCUSD")
        default:
            return instrumentName
        }
    }
    
    init() {
        ratesByInstrumentName = UserDefaultsManager().cachedInstrumentsRates.rates
    }
    
    func saveLastRatesToUserDefaults() {
        let thisDate = Date()
        UserDefaultsManager().cachedInstrumentsRates = InstrumentsRates(rates: ratesByInstrumentName,
                                                                        date: "\(thisDate)")
    }
    
    /*
    func downloadInstrumentsRatesFromYahoo(completed: @escaping DownloadComplete) {
        
        guard let url = URL(string: Constants.yahooBaseURL) else { return }
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let value = response.result.value as? Dictionary<String, Any>
                else { return }
            guard let queryResult = value["query"] as? Dictionary<String, Any>
                else { return }
            guard let resourcesRate = queryResult["results"] as? Dictionary<String, [Any]>
                else { return }
            guard let resourcesArray = resourcesRate["rate"] as? [Dictionary<String, Any>]
                else { return }
            
            for resource in resourcesArray {
                
                guard let instrumentName = resource["id"] as? String else { return }
                guard let instrumentRate = resource["Rate"] as? String else { return }
                
                self.ratesByInstrumentName.updateValue(instrumentRate, forKey: instrumentName)
                self.saveLastRatesToUserDefaults()
                
            }
            
            completed()
        }
        
    }
    */
}

