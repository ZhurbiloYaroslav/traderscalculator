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
    
    private var coreDataManager: CoreDataManager!
    
    private let maxAmountOf_Positions_InFreeVersion = 9
    private let maxAmountOf_PositionsInTheList_InFreeVersion = 3
    private let maxAmountOf_Lists_InFreeVersion = 3
    private let maxAmountOf_Exports_InFreeVersion = 3
    
    private var currentAmountOf_Positions: Int {
        return coreDataManager.getAllPositions().count
    }
    
    private var currentAmountOf_Lists: Int {
        return coreDataManager.getAllListsOfPositions().count
    }
    
    private var currentAmountOf_Exports: Int {
        return UserDefaultsManager().amountOfExports
    }
    
    func canWeAddMoreRecordsWithType(type: RecordTypes, forList listOfPositions: ListOfPositions? = nil) -> Bool {
        
        if isPRO {
            return true
        }
        
        switch type {
        case .Position:
            
            let amountOfPositionsWithoutList = coreDataManager.getPositionsWithoutList().count
            if amountOfPositionsWithoutList >= maxAmountOf_PositionsInTheList_InFreeVersion {
                return false
            }
            
            if let currentListOfPositions = coreDataManager.getInstanceOfCurrentPositionsList() {
                
                let amountOfPositionsForCurrentList = coreDataManager.getPositionsForList(currentListOfPositions).count
                if amountOfPositionsForCurrentList >= maxAmountOf_PositionsInTheList_InFreeVersion {
                    return false
                }
                
            }
            
            if currentAmountOf_Positions >= maxAmountOf_Positions_InFreeVersion {
                return false
            }
            
            return true
            
        case .ListOfPositions:
            
            if currentAmountOf_Lists >= maxAmountOf_Lists_InFreeVersion {
                return false
            }
            
            guard let list = listOfPositions else {
                // Means, that we don't copy the list, only create list with positions
                return true
            }
            
            let amountOfPositionsInList = coreDataManager.getPositionsForList(list).count
            
            let amountOfPositionsAfterCopyingList = amountOfPositionsInList + currentAmountOf_Positions
            
            if amountOfPositionsAfterCopyingList >= maxAmountOf_Positions_InFreeVersion {
                return false
            }
            
            return true
            
        case .ExportOfList:
            
            if currentAmountOf_Exports < maxAmountOf_Exports_InFreeVersion {
                return true
            } else {
                return false
            }
            
        }
    }
    
    private var isPRO: Bool {
        return UserDefaultsManager().isProVersion
    }
    
    private init(bannerView: GADBannerView, viewConstraint: NSLayoutConstraint, tableViewToChange: UITableView?) {
        self.containerConstraintToChange = viewConstraint
        self.googleBannerView = bannerView
        self.tableViewToChange = tableViewToChange
        self.coreDataManager = CoreDataManager()
        
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
    
    enum RecordTypes {
        case Position
        case ListOfPositions
        case ExportOfList
    }
    
}
