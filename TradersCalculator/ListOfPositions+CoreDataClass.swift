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
    
    convenience init(needSave: Bool, _ listName: String, _ creationDate: NSDate, _ position: NSSet) {
        
        let coreDataManager = CoreDataManager()
        
        let listOfPositions = NSEntityDescription.entity(forEntityName: "ListOfPositions", in: coreDataManager.context)!
        
        if(needSave) {
            self.init(entity: listOfPositions, insertInto: coreDataManager.context)
        } else {
            self.init(entity: listOfPositions, insertInto: nil)
        }
        
        self.listName = listName
        self.creationDate = creationDate
        self.position = position
    }
    
    convenience init(needSave: Bool) {
        let nextNameNumber = UserDefaultsManager().numberForNextListOfPositionsName
        let workingSetTitle = "Working set".localized()
        self.init(needSave: needSave, "\(workingSetTitle) \(nextNameNumber)", NSDate(), NSSet(()))
    }
}
