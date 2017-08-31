//
//  ListOfPositions+CoreDataProperties.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 30.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import CoreData


extension ListOfPositions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListOfPositions> {
        return NSFetchRequest<ListOfPositions>(entityName: "ListOfPositions")
    }

    @NSManaged public var creationDate: NSDate
    @NSManaged public var listName: String
    @NSManaged public var position: NSSet

}

// MARK: Generated accessors for position
extension ListOfPositions {

    @objc(addPositionObject:)
    @NSManaged public func addToPosition(_ value: Position)

    @objc(removePositionObject:)
    @NSManaged public func removeFromPosition(_ value: Position)

    @objc(addPosition:)
    @NSManaged public func addToPosition(_ values: NSSet)

    @objc(removePosition:)
    @NSManaged public func removeFromPosition(_ values: NSSet)

}
