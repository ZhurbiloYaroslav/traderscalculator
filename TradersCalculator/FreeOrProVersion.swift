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
    public weak var viewToChange: UIView?
    public weak var containerConstraintToChange: NSLayoutConstraint!
    
    private var isPRO: Bool {
        return UserDefaultsManager().isProVersion
    }
    
    private init(constraint: NSLayoutConstraint, tableViewToChange: UITableView?, viewToChange: UIView?) {
        self.containerConstraintToChange = constraint
        
    }
    
    public convenience init(constraint: NSLayoutConstraint, tableViewToChange: UITableView?) {
        self.init(constraint: constraint, tableViewToChange: tableViewToChange, viewToChange: nil)
    }
    
    public convenience init(constraint: NSLayoutConstraint, viewToChange: UIView?) {
        self.init(constraint: constraint, tableViewToChange: nil, viewToChange: viewToChange)
    }
    
    func removeAdIfPRO() {
        
        if isPRO {
            changeBannersVisibilityToState(true)
            
        } else {
            changeBannersVisibilityToState(false)
            containerConstraintToChange.constant = 50
            tableViewToChange?.layoutIfNeeded()
        }
        
    }
    
    func changeBannersVisibilityToState(_ needState: Bool) {
        if googleBannerView.isHidden != needState {
            googleBannerView.isHidden = needState
        }
    }
    
    func updateContainerSizeAndConstraingts() {
        if let tableView = tableViewToChange {
            
            containerConstraintToChange.constant = 0
            tableView.layoutIfNeeded()
            
        } else if let view = viewToChange {
            
            containerConstraintToChange.constant = 0
            view.layoutIfNeeded()
            
        }
    }
    
}
