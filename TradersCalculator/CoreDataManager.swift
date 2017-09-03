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
    let persStoreCoord: NSPersistentStoreCoordinator
    
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.persStoreCoord = appDelegate.persistentContainer.persistentStoreCoordinator
    }
    
    func saveInDB(_ position: Position) {
        
        print("---Saving position to DB")
        
        do {
            try context.save()
            print("---Saved position to DB")
        } catch {
            print("---", error.localizedDescription)
        }
        
    }
    
    func saveInDB(_ listOfPositions: ListOfPositions) {

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateInDB(_ position: Position) {

    }
    
    func updateInDB(_ listOfPositions: ListOfPositions) {
        
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
    
    func getInstanceOfCurrentPositionsList() -> ListOfPositions? {
        
        guard let currentListUrl = UserDefaultsManager().currentListOfPositionsID else {
            return nil
        }
        
        guard let objectID = persStoreCoord.managedObjectID(forURIRepresentation: currentListUrl) else {
            return nil
        }
        guard let listOfPositionsObject = context.object(with: objectID) as? ListOfPositions else {
            return nil
        }
        
        return listOfPositionsObject
        
    }
    
}
