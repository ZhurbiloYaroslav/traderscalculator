//
//  FirstLaunch.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 02.09.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation

class FirstLaunch {
    
    public static var isFirstLaunched: Bool {
        
        if UserDefaultsManager().leverage == nil {
            return true
        } else {
            return false
        }
    }
    
    public static func configure() {
        
        if isFirstLaunched {
            insertBaseRecordsIntoCoreData()
        }
        ForexAPI().downloadInstrumentsRates(){}
        
    }
    
    public static func insertBaseRecordsIntoCoreData() {
        
        let firstListOfPositions = ListOfPositions(needSave: true)
        CoreDataManager().saveContext()
        
        let listIdInDBURI = firstListOfPositions.objectID.uriRepresentation()
        UserDefaultsManager().currentListOfPositionsID = listIdInDBURI
        
    }
}
