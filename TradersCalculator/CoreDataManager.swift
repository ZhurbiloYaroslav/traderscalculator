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
    
    func entityForName(_ entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.context)!
    }
    
}
