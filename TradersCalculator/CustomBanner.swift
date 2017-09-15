//
//  CustomBanner.swift
//  TraderCalculator
//
//  Created by Yaroslav Zhurbilo on 15.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import UIKit

public class CustomBanner {
    
    func showAdvertAfterBannerPressed() {
        
        if let url = URL(string: "http://serv.markets.com/promoRedirect?key=ej0xNTM1MzQxNSZsPTE1MzUzNDAyJnA9Mzc1ODU="){
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
        
    }
    
}
