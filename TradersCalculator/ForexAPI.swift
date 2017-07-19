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
    
    // Rate - цена открытия
    
    func downloadForexData(completed: @escaping DownloadComplete) {
        
        guard let url = URL(string: Constants.yahooBaseURL) else { return }
        
        Alamofire.request(url).responseJSON { (response) in
            
            guard let value = response.result.value as? Dictionary<String, Any> else { return }
            
            guard let queryResult = value["query"] as? Dictionary<String, Any> else { return }
            
            print(queryResult)
            
            guard let resourcesArray = queryResult["results"] as? [Dictionary<String, Any>] else { return }
            
            for resource in resourcesArray {
                
                guard let resourceDictionary = resource["resource"] as? Dictionary<String, Any> else { return }
                guard let fieldsDictionary = resourceDictionary["fields"] as? Dictionary<String, Any> else { return }
                
                
            }
            
        }
        
    }
    
}

