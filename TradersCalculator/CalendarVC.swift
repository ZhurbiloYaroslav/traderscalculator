//
//  CalendarVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 15.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CalendarVC: UIViewController {
    
    @IBOutlet weak var googleBannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adMob
        adMob()
        
    }
    
    //ADMOB
    func adMob() {
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        googleBannerView.adUnitID = "ca-app-pub-7923953444264875/5465129548"
        googleBannerView.rootViewController = self
        googleBannerView.load(request)
        
    }

}
