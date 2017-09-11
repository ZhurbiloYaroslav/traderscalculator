//
//  OptionsVC.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 09.07.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FirebaseDatabase
import FirebaseAuth

class OptionsVC: UIViewController {
    
    @IBOutlet weak var googleBannerView: GADBannerView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerConstraintToChange: NSLayoutConstraint!
    
    var firebase: FirebaseConnect!  // Reference variable for the Database
    var adMob: AdMob!
    
    var freeOrProVersion: FreeOrProVersion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUILabelsWithLocalizedText()
        
        adMob = AdMob()
        adMob.getLittleBannerFor(viewController: self, adBannerView: googleBannerView)
        
        
        freeOrProVersion = FreeOrProVersion(bannerView: googleBannerView,
                                            constraint: containerConstraintToChange,
                                            tableViewToChange: nil)
        
    }
    
    func updateUILabelsWithLocalizedText() {
        
        navigationItem.title = "Options".localized()
        
    }
    
    func removeAdIfPRO() {
        
        let isPRO = UserDefaultsManager().isProVersion
        if isPRO {
            googleBannerView.isHidden = true
            containerTopConstraint.constant = 0
            containerView.layoutIfNeeded()
        } else {
            googleBannerView.isHidden = false
            containerTopConstraint.constant = 50
            containerView.layoutIfNeeded()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        freeOrProVersion.removeAdIfPRO()
        
        updateUILabelsWithLocalizedText()
        removeAdIfPRO()
        
    }

}








