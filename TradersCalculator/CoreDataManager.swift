//
//  CoreDataManager.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 23.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoreDataManager {
    
    private let appDelegate: AppDelegate!
    let context: NSManagedObjectContext!
    
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func saveInDBPosition(_ position: Position) {
        /*
        let entity = entityForName("Position")
        
        entity.setValue(position.dealDirection, forKey: "dealDirection")
        entity.setValue(position.instrument, forKey: "instrument")
        entity.setValue(position.openPrice, forKey: "openPrice")
        entity.setValue(position.stopLoss, forKey: "stopLoss")
        entity.setValue(position.takeProfit, forKey: "takeProfit")
        entity.setValue(position.value, forKey: "value")
        entity.setValue(Date(), forKey: "creationDate")
        */
    }
    
    func entityForName(_ entityName: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context)
    }
    
}
