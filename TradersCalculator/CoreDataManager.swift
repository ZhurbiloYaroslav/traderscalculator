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
    
    var controllerForPosition: NSFetchedResultsController<Position>!
    var controllerForListOfPositions: NSFetchedResultsController<ListOfPositions>!

    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.persStoreCoord = appDelegate.persistentContainer.persistentStoreCoordinator
    }
    
    func saveInDB(positions positionsArray: [Position], inList list: ListOfPositions?) {
        
        for position in positionsArray {
            position.listOfPositions = list
            context.insert(position)
        }
        
        saveContext()
    }
    
    func saveInDB(_ listOfPositions: ListOfPositions) {
        
        context.insert(listOfPositions)
        
        saveContext()
    }
    
    func saveContext() {

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getPositionsForList(_ listOfPositions: ListOfPositions) -> [Position] {
        
        var arrayWithPositions = [Position]()
        let fetchRequest: NSFetchRequest<Position> = Position.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "listOfPositions == %@", listOfPositions)
        
        do {
            let positions = try context.fetch(fetchRequest)
            
            for _position in positions {
                arrayWithPositions.append(_position)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        return arrayWithPositions
        
    }
    
    func getPositionsWithoutList() -> [Position] {
        
        var arrayWithPositions = [Position]()
        let fetchRequest: NSFetchRequest<Position> = Position.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "listOfPositions == nil")
        
        do {
            let positions = try context.fetch(fetchRequest)
            
            for _position in positions {
                arrayWithPositions.append(_position)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        return arrayWithPositions
        
    }
    
    func getAllPositions() -> [Position] {
        
        var arrayWithPositions = [Position]()
        let fetchRequest: NSFetchRequest<Position> = Position.fetchRequest()
        
        do {
            let positions = try context.fetch(fetchRequest)
            
            for _position in positions {
                arrayWithPositions.append(_position)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        return arrayWithPositions
    }
    
    func getAllListsOfPositions() -> [ListOfPositions] {
        
        var arrayWithListsOfPositions = [ListOfPositions]()
        let fetchRequest: NSFetchRequest<ListOfPositions> = ListOfPositions.fetchRequest()
        
        do {
            let lists = try context.fetch(fetchRequest)
            
            for _list in lists {
                arrayWithListsOfPositions.append(_list)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        return arrayWithListsOfPositions
    }
    
    func entityForName(_ entityName: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context)
    }
    
    func getInstanceOfPositionListWith(_ listName: String) -> ListOfPositions? {
        
        var listOfPositions: ListOfPositions? = nil
        let fetchRequest: NSFetchRequest<ListOfPositions> = ListOfPositions.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "listName == %@", listName)
        
        do {
            let arrayWithListOfPositions = try context.fetch(fetchRequest)
            
            if (arrayWithListOfPositions.count > 0) {
                listOfPositions = arrayWithListOfPositions[0]
            } else {
                return nil
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        return listOfPositions
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
    
    func thereIsNoListWithSimilarName(_ listName: String) -> Bool {
        
        let listWithSimilarName = getInstanceOfPositionListWith(listName)
        if listWithSimilarName == nil {
            return true
        } else {
            return false
        }
    }
}
