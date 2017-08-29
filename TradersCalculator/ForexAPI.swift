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
            
            guard let resourcesArray = response.result.value as? [Dictionary<String, Any>]
                else { return }
            
            for resource in resourcesArray {
                
                guard let instrumentName = resource["symbol"] as? String else { return }
                guard let instrumentRate = resource["bid"] as? Double else { return }
                
                self.ratesByInstrumentName.updateValue(String(instrumentRate), forKey: instrumentName)
                
            }
            
            self.saveLastRatesToUserDefaults()
            
            completed()
        }
        
    }
    
    init() {
        ratesByInstrumentName = UserDefaultsManager().cachedInstrumentsRates.rates
    }
    
    func saveLastRatesToUserDefaults() {
        UserDefaultsManager().cachedInstrumentsRates = InstrumentsRates(rates: ratesByInstrumentName, date: "2017-08-28")
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

