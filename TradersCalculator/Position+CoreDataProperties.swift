//
//  Position+CoreDataProperties.swift
//  TradersCalculator
//
//  Created by Yaroslav Zhurbilo on 31.08.17.
//  Copyright © 2017 Yaroslav Zhurbilo. All rights reserved.
//

import Foundation
import CoreData


extension Position {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Position> {
        return NSFetchRequest<Position>(entityName: "Position")
    }

    @NSManaged public var creationDate: NSDate
    @NSManaged public var dealDirection: String
    @NSManaged public var openPrice: Double
    @NSManaged public var stopLoss: Double
    @NSManaged public var takeProfit: Double
    @NSManaged public var value: Double
    @NSManaged public var listOfPositions: ListOfPositions
    @NSManaged public var instrument: Instrument

}
