//
//  ListOfPositions+CoreDataClass.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 31.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import CoreData


public class ListOfPositions: NSManagedObject {
    
    convenience init(_ listName: String, _ creationDate: NSDate, _ position: NSSet) {
        
        let coreDataManager = CoreDataManager()
        
        let listOfPositions = NSEntityDescription.entity(forEntityName: "ListOfPositions", in: coreDataManager.context)!
        
        self.init(entity: listOfPositions, insertInto: coreDataManager.context)
        self.listName = listName
        self.creationDate = creationDate
        self.position = position
    }
    
    convenience init() {
        let nextNameNumber = UserDefaultsManager().numberForNextListOfPositionsName
        self.init("Рабочий набор \(nextNameNumber)", NSDate(), NSSet(()))
    }
}
