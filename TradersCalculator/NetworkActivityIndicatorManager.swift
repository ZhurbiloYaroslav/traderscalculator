//
//  NetworkActivityIndicatorManager.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 31.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation

class NetworkActivityIndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
        
        loadingCount += 1
    }
    
    class func NetworkOperationFinished() {
        
        if loadingCount > 0 {
            
            loadingCount -= 1
            
        }
        
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
        
    }
    
}
