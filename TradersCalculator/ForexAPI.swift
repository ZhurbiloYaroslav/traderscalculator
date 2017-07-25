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
    
    var ratesByInstrumentName = Dictionary<String, [String: String]>()
    
    func downloadInstrumentsRates(completed: @escaping DownloadComplete) {
        
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
                
                let dictionary = [
                    "rate" : instrumentRate
                ]
                
                self.ratesByInstrumentName.updateValue(dictionary, forKey: instrumentName)
                
            }
            
            completed()
        }
        
    }
    
}

