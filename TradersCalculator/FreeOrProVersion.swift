//
//  FreeOrProVersion.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 11.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import GoogleMobileAds

class FreeOrProVersion {
    
    public weak var googleBannerView: GADBannerView!
    public weak var tableViewToChange: UITableView?
    public weak var containerConstraintToChange: NSLayoutConstraint!
    
    private var isPRO: Bool {
        return UserDefaultsManager().isProVersion
    }
    
    private init(bannerView: GADBannerView, viewConstraint: NSLayoutConstraint, tableViewToChange: UITableView?) {
        self.containerConstraintToChange = viewConstraint
        self.googleBannerView = bannerView
        self.tableViewToChange = tableViewToChange
        
    }
    
    public convenience init(bannerView: GADBannerView, constraint: NSLayoutConstraint, tableViewToChange: UITableView?) {
        self.init(bannerView: bannerView, viewConstraint: constraint, tableViewToChange: tableViewToChange)
    }
    
    func removeAdIfPRO() {
        
        if isPRO {
            changeBannersVisibilityToState(true)
            updateContainerSizeAndConstraingts()
            
        } else {
            changeBannersVisibilityToState(false)
            updateContainerSizeAndConstraingts()
        }
        
    }
    
    func changeBannersVisibilityToState(_ needState: Bool) {
        if googleBannerView.isHidden != needState {
            googleBannerView.isHidden = needState
        }
    }
    
    func updateContainerSizeAndConstraingts() {
        
        if isPRO {
            containerConstraintToChange.constant = 0
        } else {
            containerConstraintToChange.constant = 50
        }
        
        if let table = tableViewToChange {
            table.layoutIfNeeded()
        }
        
    }
    
}
