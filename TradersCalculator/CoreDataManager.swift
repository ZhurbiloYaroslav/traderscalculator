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
    
    func saveInDB(_ position: Position) {
        
        do {
            try context.save()
            print("---Saved position to DB")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func saveInDB(_ listOfPositions: ListOfPositions) {

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAllPositionsFor(_ listOfPositions: ListOfPositions) -> [Position] {
        
        var arrayWithPositions = [Position]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Position")
        
        do {
            let results = try context.fetch(fetchRequest)
            let positions = results as! [Position]
            
            for position in positions {
                print("---", position.instrument)
                arrayWithPositions.append(position)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        return arrayWithPositions
    }
    
    func getAllListsOfPositions() -> [ListOfPositions] {
        
        var arrayWithListsOfPositions = [ListOfPositions]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListOfPositions")
        
        do {
            let results = try context.fetch(fetchRequest)
            let allListsOfPositions = results as! [ListOfPositions]
            
            for listOfPosition in allListsOfPositions {
                print("---getAllListsOfPositions", listOfPosition.listName)
                arrayWithListsOfPositions.append(listOfPosition)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        return arrayWithListsOfPositions
    }
    
    func entityForName(_ entityName: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context)
    }
    
}
