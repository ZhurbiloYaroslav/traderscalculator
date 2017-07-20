//
//  AdMob.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 20.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class AdMob {
    
    //TODO: Make description
    func getLittleBannerFor(viewController: UIViewController, andBannerView: GADBannerView) {
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        andBannerView.adUnitID = "ca-app-pub-7923953444264875/5465129548"
        andBannerView.rootViewController = viewController
        andBannerView.load(request)
        
    }
}
