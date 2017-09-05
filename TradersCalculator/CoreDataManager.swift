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
    
    var controller: NSFetchedResultsController<Position>!
    
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.persStoreCoord = appDelegate.persistentContainer.persistentStoreCoordinator
    }
    
    func saveContext() {

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
    
    func getPositionsForCurrentList() -> [Position] {
        
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
