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
        
    }
    
    public static func insertBaseRecordsIntoCoreData() {
        let firstListOfPositions = ListOfPositions()
        let listIdInDBURI = firstListOfPositions.objectID.uriRepresentation()
        
        UserDefaultsManager().currentListOfPositionsID = listIdInDBURI
        
        CoreDataManager().saveInDB(firstListOfPositions)
        
        print("---This is first launch of the App")
    }
    
}
